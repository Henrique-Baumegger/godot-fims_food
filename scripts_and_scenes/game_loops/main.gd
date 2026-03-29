extends Node2D
class_name Main


enum GameLoops {INTRO, TABLE, SHOP, DEATH, FAILED, VICTORY, MENU}
enum Difficulties {MORTAL, GRIM, FORSAKEN}

const difficulty_to_table_sizes_track : Dictionary[Difficulties, Array] = {
	Difficulties.MORTAL : [2, 3, 3, 4],
	Difficulties.GRIM : [2, 3, 4, 4, 5],
	Difficulties.FORSAKEN : [2, 3, 4, 5, 5, 6, 6],
}

var current_table_sizes_track : Array = []
var track_index : int = 0

var current_loop : GameLoops
var loop_node : Node2D
var is_mid_transition : bool = false

@onready var persistent_accross_game_loops: PersistentAccrossGameLoops = null
@onready var scene_transition: SceneTransition = $SceneTransition


func _ready() -> void:	
	loop_node = $MainMenu
	current_loop = GameLoops.MENU
	$MainMenu.difficulty_signal.connect(start_with_difficulty)


func transition_to(to_loop: GameLoops) -> void:
	is_mid_transition = true
	await scene_transition.go_to_black()
	
	var new_scene: Node2D = AssetDictionary.instantiate_game_loop(to_loop, current_table_sizes_track[track_index])
	
	if to_loop == GameLoops.TABLE:
		var table : TableGameLoop = new_scene as TableGameLoop
		table.we_died.connect(_on_we_died)
		table.done.connect(_on_day_is_done)
		get_tree().get_first_node_in_group("day_label").text = "day "+str(track_index+1)+"/"+str(current_table_sizes_track.size())
		track_index += 1
	
	if to_loop == GameLoops.MENU:
		if persistent_accross_game_loops != null:
			persistent_accross_game_loops.queue_free()
		(new_scene as MainMenu).difficulty_signal.connect(start_with_difficulty)
	
	if current_loop == GameLoops.MENU:
		persistent_accross_game_loops = AssetDictionary.instantiate_persistent_cluster()
		add_child(persistent_accross_game_loops)
		persistent_accross_game_loops.get_button_signal().connect(_on_continue_button_pressed)
	
	add_child(new_scene)
	
	if loop_node != null:
		loop_node.queue_free()
	loop_node = new_scene
	current_loop = to_loop
	
	scene_transition.wait_and_go_to_transparent()
	is_mid_transition = false


func start_with_difficulty(dif : Difficulties) -> void:
	current_table_sizes_track = difficulty_to_table_sizes_track[dif].duplicate()
	track_index = 0
	transition_to(GameLoops.INTRO)


func _on_day_is_done(success : bool)-> void:
	if success:
		if track_index == current_table_sizes_track.size():
			transition_to(GameLoops.VICTORY)
		else:
			transition_to(GameLoops.SHOP)
	elif not success:
		transition_to(GameLoops.FAILED)


func _on_we_died()-> void:
	transition_to(GameLoops.DEATH)


func _on_continue_button_pressed() -> void:
	if is_mid_transition:
		return
	
	match current_loop:
		GameLoops.INTRO:
			transition_to(GameLoops.TABLE)
		GameLoops.SHOP:
			transition_to(GameLoops.TABLE)
		GameLoops.DEATH:
			transition_to(GameLoops.MENU)
		GameLoops.FAILED:
			transition_to(GameLoops.MENU)
		GameLoops.VICTORY:
			transition_to(GameLoops.MENU)


	
