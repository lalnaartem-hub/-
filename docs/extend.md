# Extend

## Add biome
1. Create `scenes/biomes/<biome>.tscn`.
2. Register spawn profiles in `data/world/resource_spawn_table.json`.
3. Hook generation rules in `scripts/world/world_generator.gd`.

## Add weapon
1. Import model to `models/weapons/`.
2. Add item config and damage profile in `data/balance/`.
3. Bind animation in character controller/anim tree.

## Add NPC role
1. Add role entry in `data/ai/roles.json`.
2. Update role matching in `scripts/ai/bot_ai.gd`.
