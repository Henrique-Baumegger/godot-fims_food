extends Area2D
class_name Food

var ingredients_present : Dictionary[String, int]
var max_amount_for_each_ingredient : Dictionary[String, int]
@onready var label: Label = $Label


func _ready() -> void:
	ingredients_present = AllIngredientsHelper.get_empty_ingredients_base_dictionary_copy()
	max_amount_for_each_ingredient = AllIngredientsHelper.get_max_amount_for_each_ingredient_dictionary_copy()


func try_to_add(ingredient_name: String, quantity: int) -> int:
	if not ingredients_present.has(ingredient_name):
		return -1
	
	var current := ingredients_present[ingredient_name]
	var max_allowed := max_amount_for_each_ingredient[ingredient_name]
	
	var space_left := max_allowed - current
	if space_left <= 0:
		return 0
	
	var added = min(quantity, space_left)
	ingredients_present[ingredient_name] = current + added
	
	update_label()
	return added



func update_label():
	label.text = str(ingredients_present)
