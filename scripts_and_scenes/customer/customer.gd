@abstract class_name Customer
extends Node2D


@warning_ignore("unused_signal")
signal gives_tip(amount)
signal kills_you
signal dies

# const act as static
# enum are const
enum Creatures {NONE, GHOST, SKELETON, VAMPIRE} 
const creature_type_description_BBCode : Dictionary[Creatures, String] ={
	Creatures.GHOST : "[b]GHOST[/b] - Will tip 10 doubloons before eating if dead.",
	Creatures.SKELETON : "[b]SKELETON[/b] — Doubles its poison every round end.",
	Creatures.VAMPIRE : "[b]VAMPIRE[/b] - Will tip 5 doubloons after eating if it has 0 poison."
	}

const MAX_POISON_NOT_SET : int = -1

@export var creature_type : Creatures = Creatures.NONE
@export var max_poison : int = MAX_POISON_NOT_SET
@export var tool_tip_area : ToolTipArea = null
@export var collider_of_tool_tip : CollisionShape2D = null
@export var poison_indicator : PoisonIndicator = null
@export var creature_sprite_2d : Sprite2D = null
@export var on_list_counter_marker : Marker2D = null
@export var outside_list_counter_marker : Marker2D = null

var customer_name : String 

var current_poison : int = 0
var dead : bool = false

var food_this_round : Food = null 

var is_lover : bool = false
var is_hater : bool = false
var loved_customer : Customer = null 
var hated_customer : Customer = null
var left_customer : Customer = null
var right_customer : Customer = null

var percentage_probability_mult_kill_you : float = float(1)/float(3)


#region overrides
## Override target
func start_of_round_ability() ->void:
	pass
## Override target
func end_of_round_ability() ->void:
	pass
## Override target
func start_of_day_ability() ->void:
	pass
## Override target
func end_of_day_ability() ->void:
	pass
#endregion


func make_list_format(make_list : bool) -> void:
	var list_scale = 0.625
	var normal_scale = 1.25
	if make_list:
		collider_of_tool_tip.scale = Vector2.ONE * list_scale
		creature_sprite_2d.scale = Vector2.ONE * list_scale
		poison_indicator.position = on_list_counter_marker.position
	else:
		collider_of_tool_tip.scale = Vector2.ONE * normal_scale
		creature_sprite_2d.scale = Vector2.ONE * normal_scale
		poison_indicator.position = outside_list_counter_marker.position


func eat_food() -> void:
	if dead:
		return
	
	var is_seating_next_to_hated : bool = is_hater and \
	((left_customer != null and left_customer == hated_customer )or \
	(right_customer != null and right_customer == hated_customer))
	
	var is_seating_next_to_loved : bool = is_lover and \
	((left_customer != null and left_customer == loved_customer )or \
	(right_customer != null and right_customer == loved_customer))
	
	var potential_love_multiplier = 1
	
	if is_seating_next_to_loved:
		potential_love_multiplier = 2
	if is_seating_next_to_hated:
		potential_love_multiplier = 0
	
	current_poison += potential_love_multiplier * food_this_round.ingredients_present[creature_type]
	
	food_this_round.queue_free()
	food_this_round = null
 

func dying_check() -> void:
	if dead:
		return
	if current_poison >= max_poison:
		dead = true
		dies.emit()


func killing_you_probability_check() -> void:
	if dead:
		return
	var probability := percentage_probability_mult_kill_you * (float(current_poison) / float(max_poison))
	if randf() < probability:
		emit_signal("kills_you")


func _ready() -> void:
	_check_exports()
	add_to_group("customers")


func _check_exports() -> void:
	var conditions : Array [bool] = []
	conditions.push_back(creature_type != Creatures.NONE)
	conditions.push_back(max_poison != MAX_POISON_NOT_SET)
	conditions.push_back(tool_tip_area != null)
	conditions.push_back(collider_of_tool_tip != null)
	conditions.push_back(poison_indicator != null)
	conditions.push_back(creature_sprite_2d != null)
	conditions.push_back(on_list_counter_marker != null)
	conditions.push_back(outside_list_counter_marker != null)	
	for cond in conditions:
		assert(cond, "Not all necessary export varibales of the customer parent class where set in the editor")


func _process(_delta: float) -> void:
	tool_tip_area.displayed_text = _get_updated_tool_tip_text()
	poison_indicator.set_poison_indicator(current_poison, max_poison, dead)
	if is_lover:
		poison_indicator.make_green()
	if is_hater:
		poison_indicator.make_red()


#region func tool_tip_text() -> String:
func _get_updated_tool_tip_text() -> String:
	var identity_part = "[center][b]" + customer_name + "[/b][/center]"
	if dead:
		var gravestone_path = "res://art/enviroment/gravestone good.png"
		identity_part = "[center][img=64]"+gravestone_path+"[/img][b][color=#8a8a8a] "+customer_name+" [/color][/b][img=64]"+gravestone_path+"[/img][/center]"
	
	var type_description_part : String = creature_type_description_BBCode[creature_type]
	
	var lover_part := ""
	if is_lover:
		lover_part = "\nWhile sitting next to [color=#6bff95]" + loved_customer.customer_name + "[/color] : will [color=#6bff95]eat double poison.[/color]\n"
	
	var hater_part := ""
	if is_hater:
		hater_part = "\nWhile sitting next to [color=#ff6b6b]" + hated_customer.customer_name + "[/color] : will [color=#ff6b6b]not eat.[/color]\n"
	
	var description := """{identity_part}

{type_description_part}
{lover_part}{hater_part}
[center][b]Poison: [color=#b36bff]{current_poison} / {max_poison}[/color][/b][/center]
""".format({
		"current_poison": current_poison,
		"type_description_part": type_description_part,
		"max_poison": max_poison,
		"identity_part": identity_part,
		"lover_part": lover_part,
		"hater_part": hater_part,
	})
	
	return description
#endregion












	
