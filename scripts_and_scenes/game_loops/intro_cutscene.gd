extends Node2D
class_name IntroCustscene

@onready var label: Label = $VBoxContainer/Label
@onready var label_2: Label = $VBoxContainer/Label2
@onready var label_3: Label = $VBoxContainer/Label3
@onready var label_4: Label = $VBoxContainer/Label4
@onready var label_5: Label = $VBoxContainer/Label5
@onready var monster_visual: Sprite2D = $MonsterVisual
@onready var monster_visual_2: Sprite2D = $MonsterVisual2
@onready var monster_visual_3: Sprite2D = $MonsterVisual3
@onready var monster_visual_4: Sprite2D = $MonsterVisual4
@onready var monster_visual_5: Sprite2D = $MonsterVisual5
@onready var monster_visual_6: Sprite2D = $MonsterVisual6
@onready var monster_visual_7: Sprite2D = $MonsterVisual7
@onready var monster_visual_8: Sprite2D = $MonsterVisual8
@onready var monster_visual_9: Sprite2D = $MonsterVisual9
@onready var monster_visual_10: Sprite2D = $MonsterVisual10
@onready var monster_visual_11: Sprite2D = $MonsterVisual11
@onready var monster_visual_12: Sprite2D = $MonsterVisual12
@onready var monster_visual_13: Sprite2D = $MonsterVisual13
@onready var monster_visual_14: Sprite2D = $MonsterVisual14
@onready var monster_visual_15: Sprite2D = $MonsterVisual15
@onready var monster_visual_16: Sprite2D = $MonsterVisual16
@onready var monster_visual_17: Sprite2D = $MonsterVisual17
@onready var monster_visual_18: Sprite2D = $MonsterVisual18
@onready var monster_visual_19: Sprite2D = $MonsterVisual19
@onready var monster_visual_20: Sprite2D = $MonsterVisual20
@onready var monster_visual_21: Sprite2D = $MonsterVisual21

const GHOST_1 = preload("uid://n4pmgvw48e7n")
const GHOST_2 = preload("uid://son7m30csknk")
const GHOST_3 = preload("uid://dlkeymue6jrht")
const GHOST_4 = preload("uid://03wfvm5m54sd")
const GHOST_5 = preload("uid://rac3bmnbxj8s")
const SKELETON_1 = preload("uid://clo885p4hkli1")
const SKELETON_2 = preload("uid://cc8icgq8exb6l")
const SKELETON_3 = preload("uid://d1ypgbc4ntrnc")
const SKELETON_4 = preload("uid://dwr2t2m0lnf8e")
const SKELETON_5 = preload("uid://dw81lpm0koujt")
const VAMPIRE_1 = preload("uid://dwptq3m6hknxo")
const VAMPIRE_2 = preload("uid://c72pekmj138hs")
const VAMPIRE_3 = preload("uid://byyq150c7bwg6")
const VAMPIRE_4 = preload("uid://bm26amqolheg8")
const VAMPIRE_5 = preload("uid://bmi6njxljtcf8")

var _labels: Array[Label] = []
var _monster_textures: Array[Texture2D] = []
var _sprites: Array[Sprite2D] = []


func _ready() -> void:
	_monster_textures = [
		GHOST_1, GHOST_2, GHOST_3, GHOST_4, GHOST_5,
		SKELETON_1, SKELETON_2, SKELETON_3, SKELETON_4, SKELETON_5,
		VAMPIRE_1, VAMPIRE_2, VAMPIRE_3, VAMPIRE_4, VAMPIRE_5,
	]
	_sprites = [
		monster_visual, monster_visual_2, monster_visual_3, monster_visual_4,
		monster_visual_5, monster_visual_6, monster_visual_7, monster_visual_8, 
		monster_visual_9, monster_visual_10, monster_visual_11, monster_visual_12, 
		monster_visual_13, monster_visual_14, monster_visual_15, monster_visual_16,
		monster_visual_17, monster_visual_18, monster_visual_19, monster_visual_20,  
		monster_visual_21
	]
	_labels = [label, label_2, label_3, label_4, label_5]
	
	for l in _labels:
		l.modulate.a = 0.0
	for s in _sprites:
		s.modulate.a = 0.0
	
	_reveal_paragraphs()


func _reveal_paragraphs() -> void:
	var pause : float = 3 # insert both of this on their places
	var reveal_time : float = 2.5 # I made it quicker for debugging and testing
	var tw := create_tween()
	for l in _labels:
		tw.tween_property(l, "modulate:a", 1.0, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		tw.tween_interval(0.1)
	
	await tw.finished
	var fade_in_time : float = 40
	var fade_in_delay : float = 2
	get_tree().get_first_node_in_group("persistent_accross_game_loops").fade_button_in(fade_in_time, fade_in_delay)
	_haunt_loop()


func _haunt_loop() -> void:
	while true:
		var chosen: Sprite2D = _sprites.pick_random()
		chosen.texture = _monster_textures.pick_random()
		chosen.rotation_degrees = randf_range(-15.0, 15.0)
		
		var peak_alpha := randf_range(0.10, 0.25)
		var fade_in_time := randf_range(1.5, 3.0)
		var hold_time := randf_range(0.6, 2.0)
		var fade_out_time := randf_range(1.5, 3.5)
		var delay := randf_range(0.3, 0.8)
		
		# Append all tween operations on the frame it is beeing created
		var tw := create_tween()
		tw.tween_property(chosen, "modulate:a", peak_alpha, fade_in_time) \
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_delay(delay)
		tw.tween_interval(hold_time)
		tw.tween_property(chosen, "modulate:a", 0.0, fade_out_time) \
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await tw.finished
