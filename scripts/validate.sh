#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR/terraform"

terraform fmt -check -recursive
terraform init -backend=false -input=false
terraform validate

if command -v tflint >/dev/null 2>&1; then
  tflint --init
  tflint
else
  echo "tflint not installed; skipping local lint step"
fi
