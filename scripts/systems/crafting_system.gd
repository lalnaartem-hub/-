extends Node
class_name CraftingSystem

var recipes: Dictionary = {}

func _ready() -> void:
	var file: FileAccess = FileAccess.open("res://data/recipes/basic_recipes.json", FileAccess.READ)
	if file == null:
		push_warning("Recipe file not found")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		recipes = parsed as Dictionary
	else:
		push_warning("Recipe file is invalid JSON dictionary")

func can_craft(recipe_id: String, inventory: Dictionary) -> bool:
	if not recipes.has(recipe_id):
		return false
	var recipe: Variant = recipes.get(recipe_id, {})
	if not (recipe is Dictionary):
		return false
	var ingredients: Variant = (recipe as Dictionary).get("ingredients", [])
	if not (ingredients is Array):
		return false
	for requirement_variant: Variant in ingredients:
		if not (requirement_variant is Dictionary):
			return false
		var requirement: Dictionary = requirement_variant as Dictionary
		var req_id: String = str(requirement.get("id", ""))
		var req_count: int = int(requirement.get("count", 0))
		if int(inventory.get(req_id, 0)) < req_count:
			return false
	return true
