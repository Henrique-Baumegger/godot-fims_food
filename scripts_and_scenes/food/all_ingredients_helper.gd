class_name AllIngredientsHelper


static var empty_ingredients_dictionary : Dictionary[String, int] = {
	"vampire_poison":0,
	 "ghost_poison":0,
	 "skeleton_poison":0
	}


static var max_amount_for_each_ingredient : Dictionary[String, int] = {
	"vampire_poison":5,
	 "ghost_poison":5,
	 "skeleton_poison":5
	}


static var extra_effects_ingredient_names : Array[String] = []


static func get_empty_ingredients_base_dictionary_copy() -> Dictionary[String, int]:
	return empty_ingredients_dictionary.duplicate()


static func get_max_amount_for_each_ingredient_dictionary_copy() -> Dictionary[String, int]:
	return max_amount_for_each_ingredient.duplicate()
