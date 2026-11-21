# Moreweather 3D Clouds build

Run:

```bash
bash build.sh
```

The output is:

- `dist/Moreweather_3DClouds_Shader.mcpack`
- `pack/materials/Particle.material.bin`

The build uses Lazurite to merge the `Particle` serialized material data for Minecraft Bedrock `1.26.60` and only overrides the `Transparent` pass files. Downloaded tool data and build output are stored under `.build/`, `pack/`, and `dist/` and are not source artifacts.
