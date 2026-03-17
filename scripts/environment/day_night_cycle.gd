extends Node3D
class_name DayNightCycle

@export var day_length_minutes: float = 45.0
@export var start_hour: float = 8.0
@export var sun_path: NodePath = NodePath("../SunLight")

var current_hour: float = 8.0
var sun: DirectionalLight3D

func _ready() -> void:
	current_hour = start_hour
	var sun_node: Node = get_node_or_null(sun_path)
	if sun_node is DirectionalLight3D:
		sun = sun_node as DirectionalLight3D

func _process(delta: float) -> void:
	if day_length_minutes <= 0.0:
		return
	var hours_per_second: float = 24.0 / (day_length_minutes * 60.0)
	current_hour = wrapf(current_hour + delta * hours_per_second, 0.0, 24.0)
	_update_sun()

func _update_sun() -> void:
	if sun == null:
		return
	var t: float = current_hour / 24.0
	sun.rotation.x = lerpf(-PI * 0.1, PI * 1.1, t)
	var daylight: float = max(0.0, sin(t * PI))
	sun.light_energy = 0.2 + daylight * 2.8
