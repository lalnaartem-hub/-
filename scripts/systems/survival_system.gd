extends Node
class_name SurvivalSystem

@export var hunger_decay_per_sec: float = 0.25
@export var thirst_decay_per_sec: float = 0.35
@export var fatigue_gain_per_sec: float = 0.15

var hunger: float = 100.0
var thirst: float = 100.0
var health: float = 100.0
var fatigue: float = 0.0
var temperature: float = 36.6

func _process(delta: float) -> void:
	hunger = max(0.0, hunger - hunger_decay_per_sec * delta)
	thirst = max(0.0, thirst - thirst_decay_per_sec * delta)
	fatigue = min(100.0, fatigue + fatigue_gain_per_sec * delta)
	if hunger <= 0.0 or thirst <= 0.0:
		health = max(0.0, health - 2.0 * delta)
