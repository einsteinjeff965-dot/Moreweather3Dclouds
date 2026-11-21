# Como o shader funciona (e o que ainda é suposição)

## Papel
O addon emite partículas `weather:rm_cloud` (material `particles_blend`, textura `rm_fallback.png`). Cada uma é um quad que representa um
elipsoide de nuvem. O fragment shader (`shaders/Particle/Transparent.Fragment.glsl`) faz o raymarching dentro dele.

## Como o shader sabe que é uma nuvem
`rm_fallback.png` tem o texel (0,0) com alfa = 2/255. O fragment lê esse texel com `texelFetch`; se bater, faz o raymarch. Qualquer outra
partícula do jogo segue o caminho original, sem mudança.

## Protocolo de dados (igual em `raymarch_clouds.js` do addon)
- UV do quad aponta pra uma célula do atlas 8x8 (32x32 px, com 1 px de folga): célula X = achatamento vertical do elipsoide (`RM_FLAT`),
  célula Y = raio em blocos (`RM_RADIUS`). O quad tem lado = 2 * raio.
- Cor RGB da partícula = tom da nuvem (noite/altura já aplicados pelo addon); alfa = densidade * fade.

## Suposições NÃO verificadas (testar no aparelho)
1. A posição da câmera é recuperada resolvendo `u_viewProj` (x_clip = y_clip = w_clip = 0), sem supor espaço camera-relative.
2. Direita/cima do billboard vêm das linhas 0 e 1 de `u_viewProj`. Se a nuvem sair de cabeça pra baixo ou espelhada: `RM_FLIP_Y` / `RM_FLIP_X`.
3. `LightWorldSpaceDirection` pode vir zerado em partículas; nesse caso usa um sol fixo. Se vier com sentido invertido, o código já força `y > 0`.
4. O blend de `particles_blend` é SRC_ALPHA / ONE_MINUS_SRC_ALPHA (por isso a cor é "des-premultiplicada" no fim).
5. Custo: 22 passos + 3 de sombra por pixel. Em celular pode pesar; ajustar `RM_STEPS` / `RM_LIGHT_STEPS` no topo do fragment.
6. O `AlphaTest.Vertex.glsl` foi alterado só pra manter os mesmos varyings; `AlphaTest.Fragment.glsl` não foi tocado.
