# Architecture

## Runtime modules
- `scripts/player/player_controller.gd`: accelerated movement, jump physics, mouse-look camera pivot.
- `scripts/world/world_generator.gd`: map/biome generation parameters, clamped map sizing, spawn-zone output.
- `scripts/world/resource_spawner.gd`: resource spawn event dispatch from JSON tables with strict parse checks.
- `scripts/systems/survival_system.gd`: hunger, thirst, fatigue, health decay loop.
- `scripts/systems/inventory_system.gd`: slot-based inventory with weight limits and remove-item support.
- `scripts/systems/crafting_system.gd`: recipe parsing + craft requirement validation.
- `scripts/systems/building_system.gd`: tiered durability (wood/stone/metal).
- `scripts/systems/raid_system.gd`: raid plan generation and attacker scaling.
- `scripts/ai/bot_ai.gd`: role-driven AI state switching with patrol/chase movement modes.
- `scripts/ai/behavior/raid_tactics.gd`: entry strategy selection for raids.
- `scripts/network/multiplayer_manager.gd`: ENet host/join bootstrap with return-status and error signaling.
- `scripts/environment/day_night_cycle.gd`: global time progression and dynamic sun rotation/energy.
- `scripts/environment/weather_controller.gd`: weighted weather transitions + event bus signals.

## Binary delivery model
- Git stores source and configs only.
- Binary assets (`models/**/*.glb`, `textures/materials/*.png`) are generated locally with `tools/setup_local_assets.sh`.
- This avoids Git host limitations around binary attachments on restricted platforms.

## Scene composition
- Main entry: `scenes/main_scene.tscn`
- Visual setup in main scene: `WorldEnvironment`, procedural sky, glow/SSAO/SDFGI, directional sunlight.
- Biomes: `scenes/biomes/*.tscn`
- NPC pack: `scenes/npcs/bots.tscn`
- Combined reusable model pack: `scenes/prefabs/four_model_combined.tscn`

## Asset pipeline guarantees
- License whitelist: CC0 / CC0-1.0 / Public Domain.
- Safe-target validation: `.glb` only, no parent traversal.
- SHA256 manifest per imported/derived asset.
- Retry + timeout + dry-run support for CI/preflight.

## Data-driven files
- Recipes: `data/recipes/basic_recipes.json`
- World spawn/respawn: `data/world/resource_spawn_table.json`
- Gameplay multipliers: `data/balance/gameplay.json`
- AI role tuning: `data/ai/roles.json`
