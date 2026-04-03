extends HBoxContainer
class_name LifeManager

const max_life = 6

@export var full_hat : Texture2D = null
@export var broken_hat : Texture2D = null

var all_hats : Array[TextureRect] = []
var current_life = max_life

@onready var hat_1: TextureRect = $Hat1
@onready var hat_2: TextureRect = $Hat2
@onready var hat_3: TextureRect = $Hat3
@onready var hat_4: TextureRect = $Hat4
@onready var hat_5: TextureRect = $Hat5
@onready var hat_6: TextureRect = $Hat6


func get_life() -> int:
	return current_life


func fill_life() -> void:
	current_life = max_life


func add_life_and_return_is_dead(amount : int) -> bool:
	current_life = max(current_life + amount , 0)
	var is_dead : bool = (current_life == 0)
	return is_dead


func _ready() -> void:
	_check_exports()
	all_hats = [hat_1, hat_2, hat_3, hat_4, hat_5, hat_6]	


func _process(_delta: float) -> void:
	_update_hat_visuals()


func _update_hat_visuals() -> void:
	for i in range(current_life):
		all_hats[(max_life-1)-i].texture = full_hat
	for i in range(max_life - current_life):
		all_hats[i].texture = broken_hat


func _check_exports() -> void:
	assert(full_hat != null)
	assert(broken_hat != null)
