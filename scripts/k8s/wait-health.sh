#!/usr/bin/env bash
# Poll Parko API /api/healthz for up to MAX_SECONDS after a Kubernetes deploy.
# Exits 0 only on HTTP 200 with ok:true in JSON body.
set -euo pipefail

NAMESPACE="${NAMESPACE:-parko}"
DEPLOYMENT="${DEPLOYMENT:-parko-api}"
LOCAL_PORT="${LOCAL_PORT:-18080}"
MAX_SECONDS="${MAX_SECONDS:-120}"
HEALTH_PATH="${HEALTH_PATH:-/api/healthz}"

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required" >&2
  exit 1
fi
if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi

echo "==> Waiting for deployment/${DEPLOYMENT} rollout in namespace ${NAMESPACE}"
kubectl -n "${NAMESPACE}" rollout status "deployment/${DEPLOYMENT}" --timeout=5m

echo "==> Port-forward deployment/${DEPLOYMENT} -> localhost:${LOCAL_PORT}"
kubectl -n "${NAMESPACE}" port-forward "deployment/${DEPLOYMENT}" "${LOCAL_PORT}:3000" >/tmp/parko-pf.log 2>&1 &
PF_PID=$!
cleanup() {
  kill "${PF_PID}" 2>/dev/null || true
}
trap cleanup EXIT

sleep 3

BASE_URL="http://127.0.0.1:${LOCAL_PORT}${HEALTH_PATH}"
echo "==> Polling ${BASE_URL} for up to ${MAX_SECONDS}s"

for ((i = 1; i <= MAX_SECONDS; i++)); do
  HTTP_CODE="$(curl -s -o /tmp/parko-health.json -w "%{http_code}" "${BASE_URL}" || echo "000")"
  if [[ "${HTTP_CODE}" == "200" ]]; then
    if grep -q '"ok"[[:space:]]*:[[:space:]]*true' /tmp/parko-health.json; then
      echo "==> Health check passed (${i}s)"
      cat /tmp/parko-health.json
      exit 0
    fi
  fi
  if (( i % 15 == 0 )); then
    echo "... still waiting (${i}/${MAX_SECONDS}s, last HTTP ${HTTP_CODE})"
  fi
  sleep 1
done

echo "==> Health check FAILED after ${MAX_SECONDS}s"
cat /tmp/parko-health.json 2>/dev/null || true
exit 1
