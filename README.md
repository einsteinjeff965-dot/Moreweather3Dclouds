# Moreweather — 3D Clouds shader

Shader de referência (já portado para o shader de partículas real do jogo, extraído de
[mcbe-shader-codebase](https://github.com/veka0/mcbe-shader-codebase)) + esqueleto de build para o GitHub Actions.

**Estado:** o shader foi escrito mas NÃO foi compilado nem testado. `build.sh` ainda é um esqueleto (os passos TODO).

## Pelo celular
1. Suba todos os arquivos deste zip pro repositório (Add file → Upload files, depois Commit).
2. Abra o Agent do GitHub e cole o conteúdo de `AGENT_PROMPT.md`.
3. Quando o workflow passar, baixe o `.mcpack` em Actions → o último run → Artifacts.
4. No MB Loader: Configurações → Import addon → escolha o `.mcpack`; no jogo ative em Configurações → Recursos Globais.
5. No addon Moreweather 0.18.321: menu → botão **3D Clouds** (ou `/scriptevent weather:clouds3d on`).

Sem o shader ativo, a opção "3D Clouds" mostra puffs macios no lugar da nuvem.
