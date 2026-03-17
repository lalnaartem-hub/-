extends Node
class_name CraftingSystem

var recipes: Dictionary = {}

func _ready() -> void:
	var file := FileAccess.open("res://data/recipes/basic_recipes.json", FileAccess.READ)
	if file == null:
		push_warning("Recipe file not found")
		return
	var parsed := JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		recipes = parsed
	else:
		push_warning("Recipe file is invalid JSON dictionary")

func can_craft(recipe_id: String, inventory: Dictionary) -> bool:
	if not recipes.has(recipe_id):
		return false
	for requirement in recipes[recipe_id]["ingredients"]:
		if inventory.get(requirement["id"], 0) < requirement["count"]:
			return false
	return true
