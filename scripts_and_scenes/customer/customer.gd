@abstract class_name Customer
extends Node2D

var current_poison : int = 0
var food_this_round : Food = null # Should be assigned by game loop each round
var dead : bool = false
var identity_name : String 
var likes : String
var hates : String
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
@abstract func get_poison_indicator() -> PoisonIndicator


func _ready() -> void:
	add_to_group("customers")
	add_to_group("round_dependers")
	set_max_poison_and_client_type()


func _process(_delta: float) -> void:
	get_tool_tip_area().displayed_text = tool_tip_text()
	get_poison_indicator().set_poison_indicator(current_poison, max_poison, dead)


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
	current_poison += food_this_round.ingredients_present[client_type + "_poison"]
	food_this_round = null
 



#region func tool_tip_text() -> String:
func tool_tip_text() -> String:
	var identity_part = "[center][b]"+identity_name+"[/b][/center]"
	if dead:
		identity_part = "[center][img=64]res://art/enviroment/gravestone good.png[/img][b][color=#8a8a8a] "+identity_name+" [/color][/b][img=64]res://art/enviroment/gravestone good.png[/img][/center]"
	var type_description
	if client_type == "skeleton":
		type_description = "[b]SKELETON[/b] — Doubles its poison every round end."
	elif client_type == "vampire":
		type_description = "[b]VAMPIRE[/b] - Will tip 5 doubloons after eating if it has 0 poison."
	elif client_type == "ghost":
		type_description = "[b]GHOST[/b] - Will tip 10 doubloons before eating if dead."
	
	var description := """{identity_part}

{type_description}

When sitting next to [color=#6bff95]{likes}[/color] will [color=#6bff95]eat double the poison[/color] this round.

When sitting next to [color=#ff6b6b]{hates}[/color] will [color=#ff6b6b]eat no poison[/color] this round.

[center][b]Poison: [color=#b36bff]{current_poison} / {max_poison}[/color][/b][/center]
""".format({
	"likes": likes,
	"hates": hates, 
	"current_poison": current_poison,
	"type_description": type_description,
	"max_poison": max_poison,
	"identity_part": identity_part
})
	return description
#endregion



	
