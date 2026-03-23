class_name Food
extends Area2D


enum Drinks {NONE, GO_LEFT, GO_RIGHT, STAY}
const drink_to_offset : Dictionary [Drinks, int] = {
	Drinks.GO_LEFT : -1 ,
	Drinks.GO_RIGHT : 1 ,
	Drinks.STAY : 0
}

@export var list_of_warm_food_textures : Array[Texture2D]

var current_drink_texture : Texture = null
var sprite_of_poison_type: Dictionary[Customer.Creatures, Sprite2D]

var poison_present : Dictionary[Customer.Creatures, int] ={}
var single_drink_present : Drinks = Drinks.NONE

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var food_sprite: Sprite2D = $FoodSprite
@onready var drink_sprite: Sprite2D = $DrinkSprite


func try_to_add(ing: Ingredient, quantity: int) -> int:
	var added = 0
	
	if ing.is_holly_water:
		for creature in Customer.Creatures.values():
			if creature == Customer.Creatures.NONE:
				continue
			var current = poison_present.get(creature, 0)
			poison_present[creature] = current + quantity
		added = quantity
		
	elif ing.poison_type != Customer.Creatures.NONE:
		var current = poison_present.get(ing.poison_type, 0)
		poison_present[ing.poison_type] = current + quantity
		added = quantity
		
	elif ing.drink_type != Drinks.NONE:
		if single_drink_present != ing.drink_type:
			single_drink_present = ing.drink_type
			added = 1
			current_drink_texture = ing.current_texture
		elif single_drink_present == ing.drink_type:
			added = 0
	
	_update_visuals()
	return added


func _ready() -> void:
	sprite_of_poison_type = {
		Customer.Creatures.GHOST: $MiniSilver,
		Customer.Creatures.SKELETON: $MiniSalt,
		Customer.Creatures.VAMPIRE: $MiniGarlic
	}
	food_sprite.texture = list_of_warm_food_textures.pick_random()


func _update_visuals() -> void:
	var lines: Array[String] = []
	
	for poison_type in Customer.Creatures.values():
		if poison_type == Customer.Creatures.NONE:
			continue
		var current = poison_present.get(poison_type, 0)
		if current == 0:
			sprite_of_poison_type[poison_type].visible = false
			lines.append("")
		elif current > 0:
			sprite_of_poison_type[poison_type].visible = true
			lines.append("%d" %current)
	rich_text_label.visible = true
	rich_text_label.text = "\n".join(lines)
	
	if single_drink_present != Drinks.NONE:
		drink_sprite.visible = true
		drink_sprite.texture = current_drink_texture







	
