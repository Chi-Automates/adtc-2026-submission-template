#!/usr/bin/env bash
set -euo pipefail

# Download the model weights to model/ — idempotent, no credentials needed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_DIR="$SCRIPT_DIR/model"
TARGET="$MODEL_DIR/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
URL="https://huggingface.co/bartowski/Qwen2.5-3B-Instruct-GGUF/resolve/main/Qwen2.5-3B-Instruct-Q4_K_M.gguf"

mkdir -p "$MODEL_DIR"

if [ -f "$TARGET" ]; then
  echo "Model already present at $TARGET — skipping download."
  exit 0
fi

echo "Downloading model to $TARGET ..."
if command -v wget >/dev/null 2>&1; then
  wget -O "$TARGET" "$URL"
else
  curl -L -o "$TARGET" "$URL"
fi
echo "Done."
