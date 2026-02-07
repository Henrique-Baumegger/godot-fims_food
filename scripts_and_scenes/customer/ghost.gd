extends Customer
class_name Ghost

static var id = 0

var this_instance_id
const dead_tip_amount = 10

@export var alive_sprites: Array[Texture2D]
@export var dead_sprites: Array[Texture2D]
const names : Array[String] = ["Phantom of Grief", "Ghost of Greed", "Spirit of distrust", "Specter of hatred", "Linda"]

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var tool_tip_area: Area2D = $ToolTipArea
@onready var poison_indicator: PoisonIndicator = $PoisonIndicator


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
	client_type = "ghost"


func extra_child_finish_round_logic() -> void:
	if dead:
		gives_tip.emit(dead_tip_amount)
