extends Node2D
class_name Main


enum GameLoops {INTRO, TABLE, SHOP}

var current_loop : GameLoops

@onready var persistent_accross_game_loops: PersistentAccrossGameLoops = $PersistentAccrossGameLoops
@onready var scene_transition: SceneTransition = $SceneTransition


func _ready() -> void:
	persistent_accross_game_loops.get_button_signal().connect(_on_continue_button_pressed)
	persistent_accross_game_loops.toggle_visibility(false)
	to_intro_game_loop()


func to_intro_game_loop() -> void:
	await scene_transition.go_to_black()
	current_loop = GameLoops.INTRO
	persistent_accross_game_loops.set_button_text("Cook for them")
	
	var intro_cutscene : IntroCustscene = AssetDictionary.instantiate_game_loop(GameLoops.INTRO, -1)
	var fade_in_time : float = 40
	var fade_in_delay : float = 2
	intro_cutscene.done.connect(persistent_accross_game_loops.fade_button_in.bind(fade_in_time, fade_in_delay), CONNECT_ONE_SHOT)
	add_child(intro_cutscene)
	
	scene_transition.wait_and_go_to_transparent()


func _on_continue_button_pressed() -> void:
	if current_loop==GameLoops.INTRO or current_loop==GameLoops.SHOP:
		to_table_game_loop()


func to_table_game_loop() -> void:
	await scene_transition.go_to_black()
	current_loop = GameLoops.TABLE
	
	var size = 4
	
	var table_loop_scene : TableGameLoop = AssetDictionary.instantiate_game_loop(GameLoops.TABLE, size)
	add_child(table_loop_scene)
	
	scene_transition.wait_and_go_to_transparent()








	
