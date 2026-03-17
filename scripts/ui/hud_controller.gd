extends CanvasLayer

func set_stats(health: float, hunger: float, thirst: float) -> void:
	$StatsLabel.text = "HP:%d Hunger:%d Thirst:%d" % [health, hunger, thirst]
