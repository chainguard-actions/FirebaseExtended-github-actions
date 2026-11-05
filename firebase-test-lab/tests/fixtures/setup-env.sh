#!/usr/bin/env bash
# Shared test setup for the Firebase Test Lab action.
# - Creates /tmp/ftl-fakebin and puts it on PATH (tests drop a fake gcloud there).
# - Ensures a `python` command exists (the action calls `python`).
# - Provides a minimal `imp` stub if the interpreter no longer ships `imp` (3.12+).
set -euo pipefail

FAKEBIN=/tmp/ftl-fakebin
mkdir -p "$FAKEBIN"
rm -f /tmp/ftl-gcloud-calls.log

PY3="$(command -v python3 || true)"
if [ -z "$PY3" ]; then
  PY3="$(command -v python || true)"
fi
if [ -z "$PY3" ]; then
  echo "No python interpreter available on the runner"
  exit 1
fi
if ! command -v python >/dev/null 2>&1 || ! python -c 'import sys; sys.exit(0 if sys.version_info[0] == 3 else 1)' 2>/dev/null; then
  ln -sf "$PY3" "$FAKEBIN/python"
fi

if ! "$PY3" -c 'import imp' 2>/dev/null; then
  mkdir -p /tmp/ftl-pystub
  cat > /tmp/ftl-pystub/imp.py <<'EOF'
"""Minimal stand-in for the removed stdlib `imp` module (tests only)."""
import importlib.util
import sys


def load_source(name, pathname):
    safe_name = name.replace("/", "_").replace(".", "_")
    spec = importlib.util.spec_from_file_location(safe_name, pathname)
    module = importlib.util.module_from_spec(spec)
    sys.modules[safe_name] = module
    spec.loader.exec_module(module)
    return module
EOF
  echo "PYTHONPATH=/tmp/ftl-pystub" >> "$GITHUB_ENV"
fi

echo "PYTHONUTF8=1" >> "$GITHUB_ENV"
echo "$FAKEBIN" >> "$GITHUB_PATH"
echo "python used: $PY3 ($("$PY3" --version 2>&1))"
