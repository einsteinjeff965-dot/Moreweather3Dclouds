#!/usr/bin/env bash
# PONTO DE PARTIDA — ainda NÃO compila nada. O agente (ou você) precisa completar os passos marcados TODO.
# Saída esperada: pack/materials/Particle.material.bin  e  dist/Moreweather_3DClouds_Shader.mcpack
set -euo pipefail
echo "== lazurite =="
lazurite --help || python -m lazurite --help || true
echo
echo "TODO 1: obter o Particle.material.bin ORIGINAL da versão alvo (Android, 1.26.x). Veja como o Newb X faz o './build.sh setup'"
echo "        (https://github.com/devendrn/newb-x-mcbe) e como baixa os 'material data'."
echo "TODO 2: com o lazurite (docs: https://veka0.github.io/lazurite — páginas Commands e Projects), trocar, na passada Transparent do material"
echo "        Particle, o vertex e o fragment por shaders/Particle/Transparent.Vertex.glsl e Transparent.Fragment.glsl (+ varying.def.sc)."
echo "        As outras passadas (AlphaTest etc.) ficam como no original."
echo "TODO 3: compilar com shaderc pra Android e salvar em pack/materials/Particle.material.bin"
echo "TODO 4: mkdir -p dist && (cd pack && zip -r ../dist/Moreweather_3DClouds_Shader.mcpack .)"
echo
echo "build.sh ainda não está completo." >&2
exit 1
