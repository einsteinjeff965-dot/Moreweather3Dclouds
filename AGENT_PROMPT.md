# Prompt para colar no Agent do GitHub (Copilot)

Você está num repositório com um shader de partículas modificado do Minecraft Bedrock (RenderDragon) que faz raymarching de nuvens,
usado por um addon chamado Moreweather. Leia `README.md` e `NOTES.md` primeiro.

Objetivo: fazer o workflow `.github/workflows/build.yml` gerar um `.mcpack` (artifact) contendo `materials/Particle.material.bin`
compilado para **Android, Minecraft Bedrock 1.26.x**, a partir dos shaders em `shaders/Particle/`.

Passos:
1. Leia a documentação do lazurite (https://veka0.github.io/lazurite — Commands, Material Format, Projects, Getting Started) e como o
   projeto https://github.com/devendrn/newb-x-mcbe monta o build (`build.sh setup`, `build.sh mats -p android`): de onde vêm o shaderc
   e os "material data" / .material.bin originais.
2. Complete `build.sh`: obter o `Particle.material.bin` original da versão alvo, substituir só a passada **Transparent** (vertex + fragment +
   varying.def.sc) pelos arquivos de `shaders/Particle/`, compilar com shaderc para Android e escrever `pack/materials/Particle.material.bin`.
   Depois zipar `pack/` em `dist/Moreweather_3DClouds_Shader.mcpack`.
3. As outras passadas e materiais NÃO podem mudar. Compare com `shaders/Particle_original/` (cópia do original).
4. Se a compilação falhar por causa do código do shader (nomes de uniformes, `inverse`/`transpose`, arrays constantes, tipos), corrija em
   `shaders/Particle/` mantendo a lógica descrita em `NOTES.md`, e explique cada mudança no pull request.
5. Abra um pull request com o build funcionando e uma lista curta do que foi preciso mudar e do que ficou sem poder ser verificado.

Não invente comandos do lazurite: confira na documentação. Se algo não puder ser feito no GitHub Actions, diga qual e por quê.
