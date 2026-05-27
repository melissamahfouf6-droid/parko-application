#!/usr/bin/env bash
# Send deployment / rollback alerts to Slack and Discord (optional webhooks).
set -euo pipefail

TITLE="${1:-Parko notification}"
MESSAGE="${2:-No details provided.}"
SEVERITY="${3:-error}"

SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"
DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"

if [[ -z "${SLACK_WEBHOOK_URL}" && -z "${DISCORD_WEBHOOK_URL}" ]]; then
  echo "No SLACK_WEBHOOK_URL or DISCORD_WEBHOOK_URL set — skipping alerts."
  exit 0
fi

EMOJI=":warning:"
[[ "${SEVERITY}" == "success" ]] && EMOJI=":white_check_mark:"
[[ "${SEVERITY}" == "error" ]] && EMOJI=":rotating_light:"

RUN_URL="${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-unknown}/actions/runs/${GITHUB_RUN_ID:-local}"
FULL_MESSAGE="${EMOJI} *${TITLE}*

${MESSAGE}

Run: ${RUN_URL}"

send_slack() {
  [[ -z "${SLACK_WEBHOOK_URL}" ]] && return 0
  local payload
  payload="$(python3 - <<PY
import json, os
print(json.dumps({"text": os.environ["FULL_MESSAGE"]}))
PY
)"
  curl -sfS -X POST -H 'Content-type: application/json' -d "${payload}" "${SLACK_WEBHOOK_URL}" >/dev/null
  echo "Slack alert sent."
}

send_discord() {
  [[ -z "${DISCORD_WEBHOOK_URL}" ]] && return 0
  local payload
  payload="$(python3 - <<PY
import json, os
print(json.dumps({"content": os.environ["FULL_MESSAGE"][:2000]}))
PY
)"
  curl -sfS -X POST -H 'Content-Type: application/json' -d "${payload}" "${DISCORD_WEBHOOK_URL}" >/dev/null
  echo "Discord alert sent."
}

export FULL_MESSAGE
send_slack
send_discord
