class_name Food
extends Area2D


enum Drinks {NONE, GO_LEFT, GO_RIGHT, STAY}
const drink_to_offset : Dictionary [Drinks, int] = {
	Drinks.GO_LEFT : -1 ,
	Drinks.GO_RIGHT : 1 ,
	Drinks.STAY : 0
}

@export var list_of_warm_food_textures : Array[Texture2D]

var eat_duration : float = 3

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


func slowely_dissapear() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(rich_text_label, "modulate:a", 0.0, eat_duration)
	tween.tween_property(food_sprite, "modulate:a", 0.0, eat_duration)
	tween.tween_property(drink_sprite, "modulate:a", 0.0, eat_duration)
	for sprite in sprite_of_poison_type.values():
		tween.tween_property(sprite, "modulate:a", 0.0, eat_duration)
	
	await tween.finished
	queue_free()


func be_eaten() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	rich_text_label.visible = false
	for sprite in sprite_of_poison_type.values():
		sprite.visible = false
	
	# bite animation 
	var bite_scales := [0.65, 0.35, 0.12]
	var bite_segment := eat_duration / 3.0
	var tween : Tween = create_tween()
	var tween_for_drink : Tween = create_tween()
	
	for i in 3:
		var wait_time = randf_range(bite_segment * 0.05, bite_segment * 0.35)
		tween.tween_interval(wait_time)
		tween_for_drink.tween_interval(wait_time)
		
		# crunch: scale down + random rotation
		var angle := randf_range(-30.0, 30.0)
		tween.set_parallel(true)
		tween.tween_property(food_sprite, "scale", Vector2.ONE * bite_scales[i], 0.08).set_trans(Tween.TRANS_BACK)
		tween.tween_property(food_sprite, "rotation_degrees", angle, 0.08)
		tween.set_parallel(false)
		
		tween_for_drink.set_parallel(true)
		tween_for_drink.tween_property(drink_sprite, "scale", Vector2.ONE * bite_scales[i], 0.08).set_trans(Tween.TRANS_BACK)
		tween_for_drink.tween_property(drink_sprite, "rotation_degrees", angle, 0.08)
		tween_for_drink.set_parallel(false)
		
		# wobble: bounce back toward center
		tween.tween_property(food_sprite, "rotation_degrees", -angle * 0.4, 0.10)
		tween.tween_property(drink_sprite, "rotation_degrees", -angle * 0.4, 0.10)
		tween.tween_property(food_sprite, "rotation_degrees", 0.0, 0.10)
		tween.tween_property(drink_sprite, "rotation_degrees", 0.0, 0.10)
		
		tween_for_drink.tween_property(drink_sprite, "rotation_degrees", -angle * 0.4, 0.10)
		tween_for_drink.tween_property(drink_sprite, "rotation_degrees", -angle * 0.4, 0.10)
		tween_for_drink.tween_property(drink_sprite, "rotation_degrees", 0.0, 0.10)
		tween_for_drink.tween_property(drink_sprite, "rotation_degrees", 0.0, 0.10)
	
	tween.tween_property(food_sprite, "modulate:a", 0.0, 0.25)
	tween.tween_property(drink_sprite, "modulate:a", 0.0, 0.25)
	await tween.finished
	queue_free()


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







	
