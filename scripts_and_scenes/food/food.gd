extends Area2D
class_name Food

var ingredients_present : Dictionary[String, int]
var max_amount_for_each_ingredient : Dictionary[String, int]
var warm_food_step : bool

@export var list_of_foo_sprites : Array[Texture]

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var food_sprite: Sprite2D = $FoodSprite
@onready var left_dessert_sprite: Sprite2D = $LeftDessertSprite
@onready var stay_dessert_sprite: Sprite2D = $StayDessertSprite
@onready var right_dessert_sprite: Sprite2D = $RightDessertSprite
@onready var mini_garlic: Sprite2D = $MiniGarlic
@onready var mini_salt: Sprite2D = $MiniSalt
@onready var mini_silver: Sprite2D = $MiniSilver


func _ready() -> void:
	warm_food_step = true
	ingredients_present = AllIngredientsHelper.get_empty_ingredients_base_dictionary_copy()
	max_amount_for_each_ingredient = AllIngredientsHelper.get_max_amount_for_each_ingredient_dictionary_copy()
	food_sprite.texture = list_of_foo_sprites.pick_random()
	rich_text_label.visible = false



func clients_go_to_table() -> void:
	warm_food_step = false


func try_to_add(ingredient_name: String, quantity: int) -> int:
	if not ingredients_present.has(ingredient_name):
		return 0
	
	if ingredient_name == "go_left_dessert" or ingredient_name == "go_right_dessert" or ingredient_name == "stay_dessert":
		var current_desserts := ingredients_present[ingredient_name]
		if current_desserts == 0:
			ingredients_present["go_left_dessert"] = 0
			ingredients_present["go_right_dessert"] = 0
			ingredients_present["stay_dessert"] = 0
			ingredients_present[ingredient_name] = 1
			left_dessert_sprite.visible = (ingredient_name == "go_left_dessert")
			right_dessert_sprite.visible = (ingredient_name == "go_right_dessert")
			stay_dessert_sprite.visible = (ingredient_name == "stay_dessert")
			update_label()
			return 1
		else:
			return 0
	
	var current := ingredients_present[ingredient_name]
	var max_allowed := max_amount_for_each_ingredient[ingredient_name]
	var space_left := max_allowed - current
	if space_left <= 0:
		return 0
	var added = min(quantity, space_left)
	ingredients_present[ingredient_name] = current + added
	update_label()
	return added



func update_label() -> void:
	rich_text_label.visible = true
	var vamp := int(ingredients_present.get("vampire_poison", 0))  
	var skel := int(ingredients_present.get("skeleton_poison", 0))
	var ghost := int(ingredients_present.get("ghost_poison", 0))   
	
	mini_garlic.visible = vamp > 0
	mini_salt.visible = skel > 0
	mini_silver.visible = ghost > 0

	var lines: Array[String] = []
	if vamp == 0:
		lines.append("")
	else: 
		lines.append(styled_number(vamp))
	if skel == 0:
		lines.append("")
	else: 
		lines.append(styled_number(skel))
	if ghost == 0:
		lines.append("")
	else: 
		lines.append(styled_number(ghost))

	rich_text_label.text = "\n".join(lines)






func styled_number(n: int) -> String:
		if n <= 0:
			return ""
		return "[b][outline_size=8][outline_color=#000000][color=#b36bff]%d[/color][/outline_color][/outline_size][/b]" % n








	
