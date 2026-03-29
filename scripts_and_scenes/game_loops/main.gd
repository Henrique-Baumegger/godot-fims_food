extends Node2D
class_name Main


enum GameLoops {INTRO, TABLE, SHOP, DEATH}

var current_loop : GameLoops
var loop_node : Node2D
var is_mid_transition : bool = false

@onready var persistent_accross_game_loops: PersistentAccrossGameLoops = $PersistentAccrossGameLoops
@onready var scene_transition: SceneTransition = $SceneTransition


func _ready() -> void:
	persistent_accross_game_loops.get_button_signal().connect(_on_continue_button_pressed)
	to_intro_game_loop()


func to_intro_game_loop() -> void:
	is_mid_transition = true
	await scene_transition.go_to_black()
	persistent_accross_game_loops.set_button_text("Cook for them")
	persistent_accross_game_loops.toggle_visibility(false)
	
	var intro_cutscene : IntroCustscene = AssetDictionary.instantiate_game_loop(GameLoops.INTRO, -1)
	add_child(intro_cutscene)
	
	if loop_node != null:
		loop_node.queue_free()
	loop_node = intro_cutscene
	current_loop = GameLoops.INTRO
	
	scene_transition.wait_and_go_to_transparent()
	is_mid_transition = false


func to_table_game_loop(size : int) -> void:
	is_mid_transition = true
	await scene_transition.go_to_black()
	
	persistent_accross_game_loops.toggle_visibility(true)
	var table_loop_scene : TableGameLoop = AssetDictionary.instantiate_game_loop(GameLoops.TABLE, size)
	add_child(table_loop_scene)
	table_loop_scene.we_died.connect(_on_we_died)
	table_loop_scene.done.connect(_on_day_is_done)
	
	if loop_node != null:
		loop_node.queue_free()
	loop_node = table_loop_scene
	current_loop = GameLoops.TABLE
	
	scene_transition.wait_and_go_to_transparent()
	is_mid_transition = false


func to_shop_loop() -> void:
	is_mid_transition = true
	await scene_transition.go_to_black()
	persistent_accross_game_loops.set_button_text("Next day")
	persistent_accross_game_loops.toggle_visibility(true)
	var shop_scene : ShopGameLoop = AssetDictionary.instantiate_game_loop(GameLoops.SHOP, -1)
	add_child(shop_scene)
	
	if loop_node != null:
		loop_node.queue_free()
	loop_node = shop_scene
	current_loop = GameLoops.SHOP
	
	scene_transition.wait_and_go_to_transparent()
	is_mid_transition = false


func to_death_game_loop() -> void:
	is_mid_transition = true
	await scene_transition.go_to_black()
	persistent_accross_game_loops.set_button_text("R.I.P.")
	persistent_accross_game_loops.toggle_visibility(false)
	
	var death_cutscene : DeathGameLoop = AssetDictionary.instantiate_game_loop(GameLoops.DEATH, -1)
	add_child(death_cutscene)
	
	if loop_node != null:
		loop_node.queue_free()
	loop_node = death_cutscene
	current_loop = GameLoops.DEATH
	
	scene_transition.wait_and_go_to_transparent()
	is_mid_transition = false


func _on_day_is_done(success : bool)-> void:
	if success:
		to_shop_loop()
	else:
		print("we failed the day")


func _on_we_died()-> void:
	to_death_game_loop()


func _on_continue_button_pressed() -> void:
	if is_mid_transition:
		return
	if current_loop==GameLoops.INTRO or current_loop==GameLoops.SHOP:
		to_table_game_loop(2)




	
