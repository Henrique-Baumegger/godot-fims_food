extends Customer
class_name Skeleton

static var id = 0

@export var sprites: Array[Texture2D]
const names : Array[String] = ["Sir calcium", "Big Bones", "Medium Bones", "Eye Brows", "Markc"]

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
	sprite_2d.texture = sprites[id]
	identity_name = names[id]


func _on_death ()-> void:
	pass


func set_max_poison_and_client_type() -> void:
	max_poison = 20
	client_type = "skeleton"


func extra_child_finish_round_logic() -> void:
	current_poison = current_poison * 2
