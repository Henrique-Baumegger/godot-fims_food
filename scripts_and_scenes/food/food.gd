## Lifecycle functions that should be called by parent:
## clients_go_drink_step()
class_name Food
extends Area2D


enum Drinks {NONE, GO_LEFT, GO_RIGHT, STAY}

@export var list_of_warm_food_textures : Array[Texture2D]
@export var drink_textures : Dictionary [Drinks, Texture2D] 

var sprite_of_poison_type: Dictionary[Customer.Creatures, Sprite2D]
var warm_food_step : bool = true

var poison_present : Dictionary[Customer.Creatures, int]
var single_drink_present : Drinks = Drinks.NONE

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var food_sprite: Sprite2D = $FoodSprite
@onready var drink_sprite: Sprite2D = $DrinkSprite


func move_to_drink_step()->void:
	warm_food_step = false


func _ready() -> void:
	sprite_of_poison_type = {
		Customer.Creatures.GHOST: $MiniSilver,
		Customer.Creatures.SKELETON: $MiniSalt,
		Customer.Creatures.VAMPIRE: $MiniGarlic
	}
	food_sprite.texture = list_of_warm_food_textures.pick_random()


func try_to_add(ing: Ingredient, quantity: int) -> int:
	var added = 0
	
	if ing.poison_type != Customer.Creatures.NONE && warm_food_step:
		var current = poison_present.get(ing.poison_type, 0)
		poison_present[ing.poison_type] = current + quantity
		added = quantity
	
	elif ing.drink_type != Drinks.NONE:
		if single_drink_present != ing.drink_type:
			single_drink_present = ing.drink_type
			added = 1
		elif single_drink_present == ing.drink_type:
			added = 0
	
	update_visuals()
	return added



func update_visuals() -> void:
	var lines: Array[String] = []
	for poison_type in Customer.Creatures:
		var current = poison_present.get(poison_type, 0)
		if current == 0:
			sprite_of_poison_type[poison_type].visible = false
			lines.append("")
		elif current > 0:
			sprite_of_poison_type[poison_type].visible = true
			lines.append("[b][outline_size=8][outline_color=#000000][color=#b36bff]%d[/color][/outline_color][/outline_size][/b]" %current)
	rich_text_label.visible = true
	rich_text_label.text = "\n".join(lines)
	
	if single_drink_present != Drinks.NONE:
		drink_sprite.visible = true
		drink_sprite.texture = drink_textures[single_drink_present]







	
