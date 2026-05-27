#!/usr/bin/env bash
# Post-deploy soak: tail Kubernetes logs for 5 minutes and fail on error spikes.
set -euo pipefail

NAMESPACE="${NAMESPACE:-parko}"
DEPLOYMENT="${DEPLOYMENT:-parko-api}"
LABEL_SELECTOR="${LABEL_SELECTOR:-app.kubernetes.io/name=parko-api}"

SOAK_SECONDS="${SOAK_SECONDS:-300}"
SAMPLE_INTERVAL="${SAMPLE_INTERVAL:-15}"

# Cumulative thresholds across the full soak window
MAX_5XX_LINES="${MAX_5XX_LINES:-10}"
MAX_CRITICAL_ERRORS="${MAX_CRITICAL_ERRORS:-5}"
MAX_ERROR_LINES="${MAX_ERROR_LINES:-30}"

# Light synthetic traffic (keeps pods active; 5xx counted from logs + probes)
SYNTHETIC_TRAFFIC="${SYNTHETIC_TRAFFIC:-true}"
LOCAL_PORT="${LOCAL_PORT:-18081}"

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required" >&2
  exit 1
fi

TOTAL_5XX=0
TOTAL_CRITICAL=0
TOTAL_ERROR_LINES=0
SYNTHETIC_5XX=0
FAIL=0

PF_PID=""
cleanup() {
  if [[ -n "${PF_PID}" ]]; then
    kill "${PF_PID}" 2>/dev/null || true
  fi
}
trap cleanup EXIT

if [[ "${SYNTHETIC_TRAFFIC}" == "true" ]] && command -v curl >/dev/null 2>&1; then
  kubectl -n "${NAMESPACE}" port-forward "deployment/${DEPLOYMENT}" "${LOCAL_PORT}:3000" >/tmp/parko-soak-pf.log 2>&1 &
  PF_PID=$!
  sleep 2
fi

count_matches() {
  local pattern="$1"
  local input="$2"
  if [[ -z "${input}" ]]; then
    echo 0
    return
  fi
  echo "${input}" | grep -E "${pattern}" 2>/dev/null | wc -l | tr -d ' '
}

fetch_logs() {
  kubectl -n "${NAMESPACE}" logs "deployment/${DEPLOYMENT}" \
    --since="${SAMPLE_INTERVAL}s" \
    --timestamps \
    --prefix=true \
    2>/dev/null || true
}

synthetic_probe() {
  [[ "${SYNTHETIC_TRAFFIC}" != "true" ]] && return 0
  command -v curl >/dev/null 2>&1 || return 0

  local paths=("/api/healthz" "/api/health" "/api/parking/lots/nearby?lat=29.3&lng=47.9")
  for path in "${paths[@]}"; do
    local code
    code="$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 \
      "http://127.0.0.1:${LOCAL_PORT}${path}" || echo "000")"
    if [[ "${code}" =~ ^5 ]]; then
      SYNTHETIC_5XX=$((SYNTHETIC_5XX + 1))
      echo "!! synthetic probe ${path} returned HTTP ${code}"
    fi
  done
}

echo "==> Soak monitor: namespace=${NAMESPACE} deployment=${DEPLOYMENT}"
echo "    duration=${SOAK_SECONDS}s interval=${SAMPLE_INTERVAL}s"
echo "    thresholds: 5xx<=${MAX_5XX_LINES} critical<=${MAX_CRITICAL_ERRORS} errors<=${MAX_ERROR_LINES}"

START=$(date +%s)
END=$((START + SOAK_SECONDS))
SAMPLE=0

while (( $(date +%s) < END )); do
  SAMPLE=$((SAMPLE + 1))
  ELAPSED=$(( $(date +%s) - START ))

  LOG_CHUNK="$(fetch_logs)"

  WINDOW_5XX="$(count_matches \
    '(\b5[0-9]{2}\b|statusCode[=: ]*5[0-9]{2}|HTTP/[0-9.]+ 5[0-9]{2}|Internal Server Error)' \
    "${LOG_CHUNK}")"
  WINDOW_CRITICAL="$(count_matches \
    '(Exception|Fatal|Traceback|UnhandledPromiseRejection|ECONNREFUSED|EADDRINUSE)' \
    "${LOG_CHUNK}")"
  WINDOW_ERRORS="$(count_matches \
    '(\[Nest\].*ERROR|Error:|ERROR \[|level=error)' \
    "${LOG_CHUNK}")"

  TOTAL_5XX=$((TOTAL_5XX + WINDOW_5XX))
  TOTAL_CRITICAL=$((TOTAL_CRITICAL + WINDOW_CRITICAL))
  TOTAL_ERROR_LINES=$((TOTAL_ERROR_LINES + WINDOW_ERRORS))

  synthetic_probe

  echo "[sample ${SAMPLE} @${ELAPSED}s] +5xx=${WINDOW_5XX} +critical=${WINDOW_CRITICAL} +errors=${WINDOW_ERRORS} | totals: 5xx=${TOTAL_5XX} critical=${TOTAL_CRITICAL} errors=${TOTAL_ERROR_LINES} synthetic_5xx=${SYNTHETIC_5XX}"

  if (( TOTAL_5XX > MAX_5XX_LINES )); then
    echo "::error::Soak failed: 5xx log lines (${TOTAL_5XX}) exceeded ${MAX_5XX_LINES}"
    FAIL=1
  fi
  if (( TOTAL_CRITICAL > MAX_CRITICAL_ERRORS )); then
    echo "::error::Soak failed: critical errors (${TOTAL_CRITICAL}) exceeded ${MAX_CRITICAL_ERRORS}"
    FAIL=1
  fi
  if (( TOTAL_ERROR_LINES > MAX_ERROR_LINES )); then
    echo "::error::Soak failed: error log lines (${TOTAL_ERROR_LINES}) exceeded ${MAX_ERROR_LINES}"
    FAIL=1
  fi
  if (( SYNTHETIC_5XX >= 3 )); then
    echo "::error::Soak failed: synthetic HTTP 5xx probes (${SYNTHETIC_5XX}) >= 3"
    FAIL=1
  fi

  if [[ "${FAIL:-0}" == "1" ]]; then
    echo "==> Recent pod logs:"
    kubectl -n "${NAMESPACE}" logs "deployment/${DEPLOYMENT}" --tail=100 || true
    exit 1
  fi

  sleep "${SAMPLE_INTERVAL}"
done

echo "==> Soak passed (${SOAK_SECONDS}s): 5xx=${TOTAL_5XX} critical=${TOTAL_CRITICAL} errors=${TOTAL_ERROR_LINES} synthetic_5xx=${SYNTHETIC_5XX}"
exit 0
