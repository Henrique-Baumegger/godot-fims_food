@abstract class_name Customer
extends Node2D

var current_poison : int = 0
var food_this_round : Food = null # Should be assigned by game loop each round
var dead : bool = false
var base_tip_amount : int = 1

var max_poison : int
var client_type : String

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
	tips_money()
	dying_check()
	killing_you_probability_check()


func tips_money() -> void:
	if dead:
		return
	gives_tip.emit(base_tip_amount)


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
 













	
