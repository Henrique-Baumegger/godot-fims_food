extends Node2D
class_name DeathGameLoop

@onready var label: Label = $VBoxContainer/Label
@onready var label_2: Label = $VBoxContainer/Label2
@onready var label_3: Label = $VBoxContainer/Label3
@onready var label_4: Label = $VBoxContainer/Label4

var _labels: Array[Label] = []


func _ready() -> void:
	_labels = [label, label_2, label_3, label_4]
	
	for l in _labels:
		l.modulate.a = 0.0
	
	_reveal_paragraphs()


func _reveal_paragraphs() -> void:
	var pause : float = 1 # insert both of this on their places
	var reveal_time : float = 1 # I made it quicker for debugging and testing
	var tw := create_tween()
	for l in _labels:
		tw.tween_property(l, "modulate:a", 1.0, reveal_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		tw.tween_interval(pause)
	
	await tw.finished
	
	var fade_in_time : float = 40
	var fade_in_delay : float = 2
	get_tree().get_first_node_in_group("persistent_accross_game_loops").fade_button_in(fade_in_time, fade_in_delay)
