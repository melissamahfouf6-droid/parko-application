#!/usr/bin/env bash
# Roll back parko-api to the last known stable image (git SHA annotation).
set -euo pipefail

NAMESPACE="${NAMESPACE:-parko}"
DEPLOYMENT="${DEPLOYMENT:-parko-api}"
IMAGE="${IMAGE:-ghcr.io/melissamahfouf6-droid/parko-api}"
KUSTOMIZE_DIR="${KUSTOMIZE_DIR:-k8s}"
REASON="${ROLLBACK_REASON:-deploy verification failed}"

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required" >&2
  exit 1
fi

FAILED_SHA="$(kubectl -n "${NAMESPACE}" get deployment "${DEPLOYMENT}" \
  -o jsonpath='{.metadata.annotations.parko\.io/deployed-sha}' 2>/dev/null || true)"
STABLE_SHA="$(kubectl -n "${NAMESPACE}" get deployment "${DEPLOYMENT}" \
  -o jsonpath='{.metadata.annotations.parko\.io/stable-sha}' 2>/dev/null || true)"
PREVIOUS_SHA="$(kubectl -n "${NAMESPACE}" get deployment "${DEPLOYMENT}" \
  -o jsonpath='{.metadata.annotations.parko\.io/previous-stable-sha}' 2>/dev/null || true)"

TARGET_SHA="${ROLLBACK_SHA:-${STABLE_SHA}}"
if [[ -z "${TARGET_SHA}" ]]; then
  TARGET_SHA="${PREVIOUS_SHA}"
fi

if [[ -z "${TARGET_SHA}" ]]; then
  echo "::error::No rollback target found (stable-sha / previous-stable-sha empty)."
  exit 1
fi

if [[ "${TARGET_SHA}" == "${FAILED_SHA}" ]]; then
  echo "::error::Rollback target equals failed SHA (${TARGET_SHA}) — aborting."
  exit 1
fi

echo "==> Rolling back ${DEPLOYMENT} in ${NAMESPACE}"
echo "    failed SHA:  ${FAILED_SHA:-unknown}"
echo "    target SHA:  ${TARGET_SHA}"
echo "    reason:      ${REASON}"

if [[ ! -d "${KUSTOMIZE_DIR}" ]]; then
  echo "kustomize dir not found: ${KUSTOMIZE_DIR}" >&2
  exit 1
fi

if command -v kustomize >/dev/null 2>&1; then
  (
    cd "${KUSTOMIZE_DIR}"
    kustomize edit set image "parko-api=${IMAGE}:${TARGET_SHA}"
    kubectl apply -k .
  )
else
  kubectl -n "${NAMESPACE}" set image "deployment/${DEPLOYMENT}" \
    "parko-api=${IMAGE}:${TARGET_SHA}"
fi

kubectl -n "${NAMESPACE}" annotate deployment "${DEPLOYMENT}" \
  "parko.io/deployed-sha=${TARGET_SHA}" \
  "parko.io/rollback-from=${FAILED_SHA:-unknown}" \
  "parko.io/rollback-at=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  "parko.io/rollback-reason=${REASON}" \
  --overwrite

kubectl -n "${NAMESPACE}" rollout status "deployment/${DEPLOYMENT}" --timeout=5m

echo "==> Verifying rolled-back deployment health"
MAX_SECONDS="${ROLLBACK_HEALTH_SECONDS:-90}" \
  bash "$(dirname "$0")/wait-health.sh"

echo "==> Rollback complete → ${TARGET_SHA}"
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "rollback_sha=${TARGET_SHA}" >> "${GITHUB_OUTPUT}"
fi
