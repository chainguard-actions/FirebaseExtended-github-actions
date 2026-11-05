#!/bin/bash
# Prepares the runner: fake gcloud on PATH, `python` available, imp shim if needed.
set -euo pipefail
FIX="$GITHUB_WORKSPACE/tests/fixtures"
BIN="$RUNNER_TEMP/fakebin"
mkdir -p "$BIN"
install -m 0755 "$FIX/fake-gcloud.sh" "$BIN/gcloud"
if ! command -v python >/dev/null 2>&1; then
  ln -sf "$(command -v python3)" "$BIN/python"
fi
echo "$BIN" >> "$GITHUB_PATH"
export PATH="$BIN:$PATH"
PY="$(command -v python)"
echo "python: $PY ($("$PY" --version 2>&1))"
if ! "$PY" -c "import imp" >/dev/null 2>&1; then
  echo "imp module missing; adding shim to PYTHONPATH"
  echo "PYTHONPATH=$FIX/pyshim" >> "$GITHUB_ENV"
fi
rm -f /tmp/fake-gcloud-*
