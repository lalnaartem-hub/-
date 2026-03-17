#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

python3 "$ROOT_DIR/tools/asset_pipeline/import_assets.py"

mkdir -p "$ROOT_DIR/textures/materials"
python3 - <<'PY'
import base64, pathlib
png_b64='iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+y6nQAAAAASUVORK5CYII='
raw=base64.b64decode(png_b64)
root=pathlib.Path('textures/materials')
for n in ['wood','stone','metal']:
    (root/f'{n}.png').write_bytes(raw)
print('textures generated')
PY

echo "Local binary assets are ready."
