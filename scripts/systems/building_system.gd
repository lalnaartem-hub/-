extends Node
class_name BuildingSystem

var durability_by_tier := {
	"wood": 100.0,
	"stone": 250.0,
	"metal": 500.0
}

func get_structure_durability(tier: String) -> float:
	return durability_by_tier.get(tier, 100.0)
