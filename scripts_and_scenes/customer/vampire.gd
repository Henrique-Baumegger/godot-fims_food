extends Customer
class_name Vampire

static var sprite_counter = 0

@export var sprites: Array[Texture2D]
var poisonless_tip_amount = 5

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	dies.connect(_on_death)
	sprite_2d.texture = sprites[sprite_counter%5]
	sprite_counter+=1


func _on_death ()-> void:
	rotation = 90


func set_max_poison_and_client_type() -> void:
	max_poison = 10
	client_type = "vampire"


func extra_child_finish_round_logic() -> void:
	if dead:
		return
	if current_poison == 0:
		gives_tip.emit(poisonless_tip_amount)
