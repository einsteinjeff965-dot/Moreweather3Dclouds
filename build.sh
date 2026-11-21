#!/usr/bin/env bash
set -euo pipefail

MC_VERSION="1.26.60"
SHADERC_URL="https://github.com/devendrn/newb-shader/releases/download/dev/shaderc-linux-x64"
MATERIAL_URL="https://github.com/devendrn/newb-shader/releases/download/dev/src-materials-${MC_VERSION}.zip"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/.build"
PROJECT="$WORK/Particle"
VANILLA="$WORK/vanilla"
MERGE="$WORK/merge"
OUT="$WORK/output"

cd "$ROOT"
rm -rf "$WORK" pack dist
mkdir -p "$WORK" "$PROJECT/shaders" "$VANILLA" "$MERGE" "$OUT" pack/materials dist

python3 -m pip install --upgrade pip >/dev/null
python3 -m pip install --upgrade lazurite >/dev/null

curl -fL "$SHADERC_URL" -o "$WORK/shaderc"
chmod +x "$WORK/shaderc"

curl -fL "$MATERIAL_URL" -o "$WORK/materials.zip"
unzip -q "$WORK/materials.zip" -d "$MERGE"

for candidate in \
  "$MERGE/Particle.material.bin" \
  "$MERGE/Particle/material.json" \
  "$MERGE/Particle"; do
  if [[ -e "$candidate" ]]; then
    cp -a "$candidate" "$VANILLA/"
  fi
done

if [[ -f "$MERGE/Particle.material.json" ]]; then
  cp -a "$MERGE/Particle.material.json" "$VANILLA/"
fi

if [[ -d "$MERGE/Particle" ]]; then
  cp -a "$MERGE/Particle" "$PROJECT/"
fi

if [[ -f "$PROJECT/Particle/material.json" ]]; then
  cp -a "$PROJECT/Particle"/* "$PROJECT/"
  rm -rf "$PROJECT/Particle"
fi

if [[ ! -f "$PROJECT/material.json" ]]; then
  echo "Particle.material.bin or serialized Particle material data was not found in $MATERIAL_URL" >&2
  exit 1
fi

cat > "$PROJECT/config.json" <<'JSON'
{
  "compiler": {
    "type": "shaderc",
    "options": []
  },
  "file_overwrite": {
    "passes": {
      "Transparent": {
        "entry_point": "main",
        "fragment": "shaders/Transparent.Fragment.sc",
        "vertex": "shaders/Transparent.Vertex.sc",
        "varying": "shaders/varying.def.sc"
      }
    }
  }
}
JSON

cat > "$WORK/project.json" <<'JSON'
{
  "base_profile": {
    "platforms": ["ESSL_300", "ESSL_310"],
    "merge_source": ["vanilla"],
    "include_patterns": ["Particle"],
    "exclude_patterns": [".*", "_*"],
    "include_search_paths": ["include"]
  },
  "profiles": {
    "android": {
      "platforms": ["ESSL_300", "ESSL_310"],
      "merge_source": ["vanilla"]
    }
  }
}
JSON

cp "$ROOT/shaders/Particle/Transparent.Fragment.glsl" "$PROJECT/shaders/Transparent.Fragment.sc"
cp "$ROOT/shaders/Particle/Transparent.Vertex.glsl" "$PROJECT/shaders/Transparent.Vertex.sc"
cp "$ROOT/shaders/Particle/varying.def.sc" "$PROJECT/shaders/varying.def.sc"

if [[ -f "$ROOT/shaders/Particle/bgfx_shader.sh" ]]; then
  cp "$ROOT/shaders/Particle/bgfx_shader.sh" "$PROJECT/shaders/bgfx_shader.sh"
else
  curl -fL "https://raw.githubusercontent.com/SurvivalApparatusCommunication/RenderDragonSourceCodeInv/1.20.60/include/bgfx_shader.sh" -o "$PROJECT/shaders/bgfx_shader.sh"
fi

python3 -m lazurite build "$WORK" -p android --shaderc "$WORK/shaderc" -o "$OUT"

built="$OUT/Particle.material.bin"
if [[ ! -f "$built" ]]; then
  built=$(find "$OUT" -name 'Particle.material.bin' -print -quit)
fi
[[ -n "$built" && -f "$built" ]] || { echo "Particle.material.bin was not produced" >&2; exit 1; }
cp "$built" pack/materials/Particle.material.bin

python3 -m lazurite info pack/materials/Particle.material.bin

echo "== verifying packed structure =="
mkdir -p "$WORK/check"
python3 -m lazurite unpack pack/materials/Particle.material.bin -o "$WORK/check"
python3 - <<'PY'
from pathlib import Path
import json

check = next(Path('.build/check').glob('Particle'))
with (check / 'passes' / 'Transparent.json').open() as f:
    transparent = json.load(f)
print('Transparent variants:', len(transparent.get('variants', [])))
PY

(cd pack && zip -qr ../dist/Moreweather_3DClouds_Shader.mcpack .)

sha256sum pack/materials/Particle.material.bin dist/Moreweather_3DClouds_Shader.mcpack
