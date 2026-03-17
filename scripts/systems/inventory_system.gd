extends Node
class_name InventorySystem

@export var slot_count: int = 30
@export var max_weight: float = 60.0

var slots: Array[Dictionary] = []
var current_weight: float = 0.0

func _ready() -> void:
	slots.clear()
	for _i in range(slot_count):
		slots.append({"item_id": "", "count": 0, "weight": 0.0})

func try_add_item(item_id: String, count: int, weight_per_item: float) -> bool:
	var added_weight := float(count) * weight_per_item
	if current_weight + added_weight > max_weight:
		return false

	for slot in slots:
		if slot["item_id"] == item_id or slot["item_id"] == "":
			slot["item_id"] = item_id
			slot["count"] += count
			slot["weight"] = weight_per_item
			current_weight += added_weight
			return true
	return false

func remove_item(item_id: String, count: int) -> bool:
	for slot in slots:
		if slot["item_id"] == item_id and slot["count"] >= count:
			slot["count"] -= count
			current_weight = max(0.0, current_weight - float(count) * float(slot["weight"]))
			if slot["count"] == 0:
				slot["item_id"] = ""
				slot["weight"] = 0.0
			return true
	return false
