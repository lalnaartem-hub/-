extends Node3D
class_name WorldGenerator

@export_range(1, 8, 1) var map_size_km: int = 4
@export var base_seed: int = 424242
@export var terrain_frequency: float = 0.0025
@export var mountain_threshold: float = 0.72
@export var swamp_threshold: float = 0.22

var rng := RandomNumberGenerator.new()

func generate_world(optional_seed: int = -1) -> Dictionary:
	var world_seed := base_seed if optional_seed < 0 else optional_seed
	rng.seed = world_seed
	var safe_map_size := clampi(map_size_km, 1, 8)
	return {
		"seed": world_seed,
		"map_size_km": safe_map_size,
		"terrain_frequency": max(0.0001, terrain_frequency),
		"biomes": {
			"forest": {"weight": 0.45},
			"mountain": {"weight": 0.30, "threshold": clampf(mountain_threshold, 0.0, 1.0)},
			"swamp": {"weight": 0.25, "threshold": clampf(swamp_threshold, 0.0, 1.0)}
		},
		"spawn_zones": _generate_spawn_zones(safe_map_size)
	}

func _generate_spawn_zones(size_km: int) -> Array[Vector3]:
	var result: Array[Vector3] = []
	for _i in range(16):
		var px := rng.randf_range(-size_km * 500.0, size_km * 500.0)
		var pz := rng.randf_range(-size_km * 500.0, size_km * 500.0)
		result.append(Vector3(px, 0.0, pz))
	return result
