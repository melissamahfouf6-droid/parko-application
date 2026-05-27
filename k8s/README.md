# Parko API on Kubernetes

## Prerequisites

- A Kubernetes cluster (1.26+)
- `kubectl` configured locally
- GitHub Actions secret **`KUBE_CONFIG`**: base64-encoded kubeconfig with deploy permissions

```bash
# Create the secret value for GitHub:
base64 -i ~/.kube/config | pbcopy
```

## Deploy manually

```bash
export IMAGE_TAG="$(git rev-parse HEAD)"
cd k8s
kustomize edit set image "parko-api=ghcr.io/melissamahfouf6-droid/parko-api:${IMAGE_TAG}"
kubectl apply -k .
bash ../scripts/k8s/wait-health.sh
```

## Health endpoints

- `GET /api/health`
- `GET /api/healthz` (used by probes and CD)

Returns **200** when SQLite is reachable; **503** when unhealthy.

## GitHub secrets

| Secret | Purpose |
|--------|---------|
| **`KUBE_CONFIG`** | Base64 kubeconfig for deploy/rollback |
| **`SLACK_WEBHOOK_URL`** | Slack incoming webhook for deploy/rollback alerts |
| **`DISCORD_WEBHOOK_URL`** | Discord webhook for deploy/rollback alerts |

```bash
base64 -i ~/.kube/config | pbcopy
```

## Automated rollback (Phase 4)

If **health** or **soak** fails after deploy, CD runs `scripts/k8s/rollback.sh`:

1. Reads `parko.io/stable-sha` (fallback: `previous-stable-sha`)
2. Re-deploys that image tag
3. Verifies `/api/healthz`
4. Sends **Slack + Discord** alerts

Manual rollback: **Actions → Rollback → Run workflow** (`.github/workflows/rollback.yml`).

## Post-deploy soak (Phase 3)

After health checks pass, CD runs `scripts/k8s/soak-monitor.sh` for **5 minutes**:

- Tails `kubectl logs` every 15s
- Fails if thresholds are exceeded:
  - HTTP **5xx** patterns in logs (default max **10** total)
  - **Exception / Fatal / Traceback** (default max **5**)
  - Nest/error log lines (default max **30**)
- Sends light synthetic traffic to `/api/healthz` and a sample API route

```bash
bash scripts/k8s/soak-monitor.sh
```

## Notes

- **SQLite** uses `emptyDir` at `/data` — use **1 replica** until you migrate to Postgres.
- Images are tagged with the **git commit SHA**, never `latest`.
