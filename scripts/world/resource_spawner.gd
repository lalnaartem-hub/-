extends Node3D
class_name ResourceSpawner

@export var spawn_table_path: String = "res://data/world/resource_spawn_table.json"

func spawn_resources() -> int:
	var file: FileAccess = FileAccess.open(spawn_table_path, FileAccess.READ)
	if file == null:
		push_warning("Spawn table not found")
		return 0

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		push_warning("Spawn table JSON is invalid")
		return 0

	var table: Dictionary = parsed as Dictionary
	var spawned: int = 0
	for resource_type_variant: Variant in table.keys():
		var resource_type: String = str(resource_type_variant)
		GameEvents.emit_resource_spawned(resource_type, Vector3.ZERO)
		spawned += 1
	return spawned
