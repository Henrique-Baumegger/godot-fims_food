@abstract class_name Customer
extends Node2D

var current_poison : int = 0
var food_this_round : Food = null # Should be assigned by game loop each round
var dead : bool = false
var identity_name : String 

var is_lover : bool
var is_hater : bool
var loved_name : String 
var hated_name : String
var left_customer : Customer = null
var right_customer : Customer = null

var percentage_probability_mult_kill_you : float = 0.333


var max_poison : int
var client_type : String

@warning_ignore("unused_signal")
signal gives_tip(amount)
signal kills_you
signal dies

@abstract func set_max_poison_and_client_type() -> void
@abstract func extra_child_finish_round_logic() ->void
@abstract func get_tool_tip_area() -> ToolTipArea
@abstract func get_collider_of_tool_tip() -> CollisionShape2D
@abstract func get_poison_indicator() -> PoisonIndicator
@abstract func get_sprite() -> Sprite2D
@abstract func get_counter_position(on_list) -> Marker2D

func _ready() -> void:
	add_to_group("customers")
	add_to_group("round_dependers")
	set_max_poison_and_client_type()


func _process(_delta: float) -> void:
	get_tool_tip_area().displayed_text = tool_tip_text()
	get_poison_indicator().set_poison_indicator(current_poison, max_poison, dead)
	if is_lover:
		get_poison_indicator() .make_green()
	if is_hater:
		get_poison_indicator() .make_red()


func list_format(make_list : bool) -> void:
	var list_scale = 0.625
	var normal_scale = 1.25
	if make_list:
		get_collider_of_tool_tip().scale = Vector2.ONE * list_scale
		get_sprite().scale = Vector2.ONE * list_scale
		get_poison_indicator().position = get_counter_position(true).position
	else:
		get_collider_of_tool_tip().scale = Vector2.ONE * normal_scale
		get_sprite().scale = Vector2.ONE * normal_scale
		get_poison_indicator().position = get_counter_position(false).position


func finish_round() -> void:
	if !dead:
		eat_food()
	
	extra_child_finish_round_logic()
	if !dead:
		dying_check()
	if !dead:
		killing_you_probability_check()


func killing_you_probability_check() -> void:
	var probability := percentage_probability_mult_kill_you * (float(current_poison) / float(max_poison))
	if randf() < probability:
		emit_signal("kills_you")


func dying_check() -> void:
	if current_poison >= max_poison:
		dead = true
		dies.emit()


func eat_food() -> void:
	var is_seating_next_to_hated : bool = is_hater and \
	((left_customer != null and left_customer.identity_name == hated_name )or \
	(right_customer != null and right_customer.identity_name == hated_name))
	
	var is_seating_next_to_loved : bool = is_lover and \
	((left_customer != null and left_customer.identity_name == loved_name )or \
	(right_customer != null and right_customer.identity_name == loved_name))
	
	var potential_love_multiplier = 1
	
	if is_seating_next_to_loved:
		potential_love_multiplier = 2
	
	if not is_seating_next_to_hated:
		current_poison += potential_love_multiplier * food_this_round.ingredients_present[client_type + "_poison"]
	
	food_this_round.queue_free()
	food_this_round = null
 



#region func tool_tip_text() -> String:
func tool_tip_text() -> String:
	var identity_part = "[center][b]" + identity_name + "[/b][/center]"
	if dead:
		identity_part = "[center][img=64]res://art/enviroment/gravestone good.png[/img][b][color=#8a8a8a] " + identity_name + " [/color][/b][img=64]res://art/enviroment/gravestone good.png[/img][/center]"
	
	var type_description: String = ""
	if client_type == "skeleton":
		type_description = "[b]SKELETON[/b] — Doubles its poison every round end."
	elif client_type == "vampire":
		type_description = "[b]VAMPIRE[/b] - Will tip 5 doubloons after eating if it has 0 poison."
	elif client_type == "ghost":
		type_description = "[b]GHOST[/b] - Will tip 10 doubloons before eating if dead."
	
	var lover_line := ""
	if is_lover:
		lover_line = "\nWhile sitting next to [color=#6bff95]" + loved_name + "[/color] : will [color=#6bff95]eat double poison.[/color]\n"
	
	var hater_line := ""
	if is_hater:
		hater_line = "\nWhile sitting next to [color=#ff6b6b]" + hated_name + "[/color] : will [color=#ff6b6b]not eat.[/color]\n"
	
	var description := """{identity_part}

{type_description}
{lover_line}{hater_line}
[center][b]Poison: [color=#b36bff]{current_poison} / {max_poison}[/color][/b][/center]
""".format({
		"current_poison": current_poison,
		"type_description": type_description,
		"max_poison": max_poison,
		"identity_part": identity_part,
		"lover_line": lover_line,
		"hater_line": hater_line,
	})
	
	return description

#endregion



	
