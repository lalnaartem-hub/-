extends Node
class_name RaidSystem

@export var min_cooldown_sec: float = 1200.0
@export var max_attackers: int = 8

func plan_raid(target_position: Vector3, difficulty: int) -> Dictionary:
	var attacker_count: int = clampi(difficulty * 2, 2, max_attackers)
	return {
		"target": target_position,
		"attackers": attacker_count,
		"path_mode": "navmesh",
		"use_traps": true
	}
