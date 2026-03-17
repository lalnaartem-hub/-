extends Node

signal weather_changed(weather: String)
signal raid_started(target_base_id: String)
signal player_stat_changed(player_id: int, stat: String, value: float)
signal resource_spawned(resource_type: String, world_position: Vector3)

func emit_weather_changed(weather: String) -> void:
	weather_changed.emit(weather)

func emit_raid_started(target_base_id: String) -> void:
	raid_started.emit(target_base_id)
