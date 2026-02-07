extends Customer
class_name Vampire

static var id = 0
var this_instance_id

@export var alive_sprites: Array[Texture2D]
@export var dead_sprites: Array[Texture2D]

const names : Array[String] = ["Ariela", "Catty", "Chad", "Margareth", "Leek"]

var poisonless_tip_amount = 5

@onready var tool_tip_area: Area2D = $ToolTipArea
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var poison_indicator: PoisonIndicator = $PoisonIndicator
@onready var collision_shape_2d: CollisionShape2D = $ToolTipArea/CollisionShape2D
@onready var normal_counter_pos: Marker2D = $NormalCounterPos
@onready var list_counter_post: Marker2D = $ListCounterPost


func get_counter_position(on_list) -> Marker2D:
	if on_list:
		return list_counter_post
	else:
		return normal_counter_pos


func get_sprite() -> Sprite2D:
	return sprite_2d


func get_collider_of_tool_tip() -> CollisionShape2D:
	return collision_shape_2d

func get_tool_tip_area() -> ToolTipArea:
	return tool_tip_area


func get_poison_indicator() -> PoisonIndicator:
	return poison_indicator


func _ready() -> void:
	super._ready()
	dies.connect(_on_death)
	id = (id+1) % 5
	this_instance_id = id
	sprite_2d.texture = alive_sprites[this_instance_id]
	identity_name = names[this_instance_id]


func _on_death ()-> void:
	sprite_2d.texture = dead_sprites[this_instance_id]



func set_max_poison_and_client_type() -> void:
	max_poison = 10
	client_type = "vampire"


func extra_child_finish_round_logic() -> void:
	if dead:
		return
	if current_poison == 0:
		gives_tip.emit(poisonless_tip_amount)
