@abstract class_name Customer
extends Node2D

var current_poison : int = 0
var food_this_round : Food = null # Should be assigned by game loop each round
var dead : bool = false
var identity_name : String = ""
var likes : String = ""
var hates : String = ""


var max_poison : int
var client_type : String

@warning_ignore("unused_signal")
signal gives_tip(amount)
signal kills_you
signal dies

@abstract func set_max_poison_and_client_type() -> void
@abstract func extra_child_finish_round_logic() ->void

func _ready() -> void:
	add_to_group("customers")
	add_to_group("round_dependers")
	set_max_poison_and_client_type()


func finish_round() -> void:
	eat_food()
	extra_child_finish_round_logic()
	dying_check()
	killing_you_probability_check()


func killing_you_probability_check() -> void:
	if dead:
		return
	var probability := 0.5 * float(current_poison) / float(max_poison)
	if randf() < probability:
		emit_signal("kills_you")


func dying_check() -> void:
	if dead:
		return
	if current_poison >= max_poison:
		dead = true
		dies.emit()


func eat_food() -> void:
	if dead:
		return
	current_poison += food_this_round.ingredients_present[client_type + "_poison"]
	food_this_round = null
 

func tool_tip_text() -> String:
	var type_description
	if client_type == "skeleton":
		type_description = "SKELETON — Doubles its poison every round end."
	elif client_type == "vampire":
		type_description = "Vampire - Will tip 5 doubloons if 0 poison."
	
	var description := """
[center][b]{identity}[/b][/center]

{type_description}

When sitting next to [color=#6bff95]{likes}[/color] will [color=#6bff95]eat double the poison[/color] this round.

When sitting next to [color=#ff6b6b]{hates}[/color] will [color=#ff6b6b]eat no poison[/color] this round.

[center][b]Poison: [color=#b36bff]{current_poison}[/color][/b][/center]
""".format({
	"identity": identity_name,
	"likes": likes,
	"hates": hates, 
	"current_poison": current_poison,
	"type_description": type_description
})
	return description




	
