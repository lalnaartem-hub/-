# OpenSurvivor (Godot 4)

Open-source Godot 4 survival open-world foundation with modular gameplay systems, CC0-oriented asset pipeline, and scalable content structure.

## Important: repository is binary-free
To avoid platform restrictions on binary files, this repository stores **scripts/scenes/config only**.
Binary assets (`.glb`, `.png`) are generated/downloaded locally.

## First step after clone
```bash
bash tools/setup_local_assets.sh
```
This command downloads CC0 models and generates placeholder textures.

## Quick start
1. Install Godot 4.2+.
2. Run `bash tools/setup_local_assets.sh`.
3. Open this folder as a Godot project.
4. Run `res://scenes/main_scene.tscn`.

## Import / refresh asset pack manually
```bash
python3 tools/asset_pipeline/import_assets.py
```

## Validate importer without downloads
```bash
python3 tools/asset_pipeline/import_assets.py --dry-run
```

## Core structure
- `scenes/` game scenes, biomes, NPCs, prefab packs, UI
- `scripts/` runtime systems and gameplay logic
- `models/`, `textures/` generated locally (git-ignored binaries)
- `data/` recipes, balance, AI, world spawn settings
- `docs/` architecture and extension guides
