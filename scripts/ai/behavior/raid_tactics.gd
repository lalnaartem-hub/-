extends Node
class_name RaidTactics

func select_entry_strategy(defense_level: float, trap_count: int) -> String:
	if trap_count > 5:
		return "ranged_breach"
	if defense_level > 0.7:
		return "flank_and_breach"
	return "direct_assault"
