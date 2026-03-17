extends Node3D
class_name DayNightCycle

@export var day_length_minutes: float = 45.0
@export var start_hour: float = 8.0
@export var sun_path: NodePath = NodePath("../SunLight")

var current_hour: float = 8.0
@onready var sun: DirectionalLight3D = get_node_or_null(sun_path)

func _ready() -> void:
	current_hour = start_hour

func _process(delta: float) -> void:
	var hours_per_second := 24.0 / (day_length_minutes * 60.0)
	current_hour = fposmod(current_hour + delta * hours_per_second, 24.0)
	_update_sun()

func _update_sun() -> void:
	if sun == null:
		return
	var t := current_hour / 24.0
	sun.rotation.x = lerp(-PI * 0.1, PI * 1.1, t)
	var daylight := max(0.0, sin(t * PI))
	sun.light_energy = 0.2 + daylight * 2.8
