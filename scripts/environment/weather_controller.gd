extends Node
class_name WeatherController

@export var weather_cycle_seconds: float = 300.0
var weather_states := [
	{"name": "clear", "weight": 0.45},
	{"name": "rain", "weight": 0.22},
	{"name": "fog", "weight": 0.17},
	{"name": "storm", "weight": 0.10},
	{"name": "snow", "weight": 0.06}
]

var timer: float = 0.0
var current_weather: String = "clear"
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func _process(delta: float) -> void:
	timer += delta
	if timer >= weather_cycle_seconds:
		timer = 0.0
		current_weather = _pick_weighted_weather()
		GameEvents.emit_weather_changed(current_weather)

func _pick_weighted_weather() -> String:
	var roll := rng.randf()
	var cumulative := 0.0
	for entry in weather_states:
		cumulative += float(entry["weight"])
		if roll <= cumulative:
			return str(entry["name"])
	return "clear"
