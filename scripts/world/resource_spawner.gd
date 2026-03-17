extends Node3D
class_name ResourceSpawner

@export var spawn_table_path: String = "res://data/world/resource_spawn_table.json"

func spawn_resources() -> int:
	var file := FileAccess.open(spawn_table_path, FileAccess.READ)
	if file == null:
		push_warning("Spawn table not found")
		return 0

	var parsed := JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Spawn table JSON is invalid")
		return 0

	var table: Dictionary = parsed
	var spawned := 0
	for resource_type in table.keys():
		GameEvents.emit_resource_spawned(resource_type, Vector3.ZERO)
		spawned += 1
	return spawned
