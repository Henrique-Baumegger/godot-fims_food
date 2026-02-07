class_name AllIngredientsHelper


static var empty_ingredients_dictionary : Dictionary[String, int] = {
	"vampire_poison":0,
	 "ghost_poison":0,
	 "skeleton_poison":0,
	"go_left_dessert":0,
	"go_right_dessert":0,
	"stay_dessert":0
	}


static var max_amount_for_each_ingredient : Dictionary[String, int] = {
	"vampire_poison":10,
	 "ghost_poison":10,
	 "skeleton_poison":20,
	"go_left_dessert":1,
	"go_right_dessert":1,
	"stay_dessert":1
	}



static func get_empty_ingredients_base_dictionary_copy() -> Dictionary[String, int]:
	return empty_ingredients_dictionary.duplicate()


static func get_max_amount_for_each_ingredient_dictionary_copy() -> Dictionary[String, int]:
	return max_amount_for_each_ingredient.duplicate()
