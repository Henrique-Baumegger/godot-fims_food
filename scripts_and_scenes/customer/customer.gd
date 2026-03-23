## LIFECYCLE methods: (owner should call these stages in a consistent order)
##   start_of_day_ability() 
##   start_of_round_ability() 
##   eat_and_free_food() 
##   after_eating_ability()
##   dying_check()
##   killing_you_probability_check()
##   end_of_round_ability()
##   end_of_day_ability()
@abstract class_name Customer
extends Node2D


@warning_ignore("unused_signal")
signal gives_tip(amount)


# const act as static
# enum are const
enum Creatures {NONE, VAMPIRE, SKELETON, GHOST} 
const creature_type_description_BBCode : Dictionary[Creatures, String] ={
	Creatures.GHOST : "[b]GHOST[/b] - tips 15 doubloons on round end if dead.",
	Creatures.SKELETON : "[b]SKELETON[/b] — doubles its poison after eating. tips 20 upon death",
	Creatures.VAMPIRE : "[b]VAMPIRE[/b] - tips equal to poison at round start."
	}

const MAX_POISON_NOT_SET : int = -1
const percentage_probability_mult_kill_you : float = float(1)/float(3)

static var id_for_names_and_textures = 0

@export var creature_type : Creatures = Creatures.NONE
@export var max_poison : int = MAX_POISON_NOT_SET
##Must have consistent index with alive_textures_per_id and dead_textures_per_id
@export var names_per_id : Array[String] = []
##Must have consistent index with names_per_id and dead_textures_per_id
@export var alive_textures_per_id : Array[Texture2D] = []
##Must have consistent index with names_per_id and alive_textures_per_id
@export var dead_textures_per_id : Array[Texture2D] = []


var this_instance_id : int
var customer_name : String 

var current_poison : int = 0
var dead : bool = false

var last_drink_eaten : Food.Drinks = Food.Drinks.NONE
var food_this_round : Food = null 

var is_lover : bool = false
var is_hater : bool = false
var loved_customer : Customer = null 
var hated_customer : Customer = null
var left_customer : Customer = null
var right_customer : Customer = null

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var poison_indicator: PoisonIndicator = $PoisonIndicator
@onready var tool_tip_area: ToolTipArea = $ToolTipArea
@onready var collider_of_tool_tip: CollisionShape2D = $ToolTipArea/CollisionShape2D
@onready var normal_counter_pos: Marker2D = $NormalCounterPos
@onready var on_list_counter_marker: Marker2D = $ListCounterPost
@onready var check_bar: CheckBar = $CheckBar


#region abstracts

@abstract func start_of_round_ability() ->void

@abstract func end_of_round_ability() ->void

@abstract func after_eating_ability() ->void

@abstract func start_of_day_ability() ->void

@abstract func end_of_day_ability() ->void

@abstract func upon_death_ability() -> void

# CRT+C , CRT+V , uncomment
#func start_of_round_ability() ->void:
	#pass
#
#
#func end_of_round_ability() ->void:
	#pass
#
#
#func after_eating_ability() ->void:
	#pass
#
#
#func start_of_day_ability() ->void:
	#pass
#
#
#func end_of_day_ability() ->void:
	#pass
#
#
#func upon_death_ability() ->void:
	#pass
#endregion


func give_food(new_food : Food) ->void:
	food_this_round = new_food


func get_and_delete_last_drink_eaten() -> Food.Drinks:
	var result : Food.Drinks = last_drink_eaten
	last_drink_eaten = Food.Drinks.NONE
	return result


func set_up_relations(loved:Customer, hated:Customer) -> void:
	if loved != null:
		loved_customer = loved
		is_lover = true
		poison_indicator.make_green()
	elif hated != null:
		hated_customer = hated
		is_hater = true
		poison_indicator.make_red()


func list_format(make_list : bool) -> void:
	var list_scale = 0.625
	var normal_scale = 1.25
	if make_list:
		collider_of_tool_tip.scale = Vector2.ONE * list_scale
		sprite_2d.scale = Vector2.ONE * list_scale
		poison_indicator.position = on_list_counter_marker.position
	else:
		collider_of_tool_tip.scale = Vector2.ONE * normal_scale
		sprite_2d.scale = Vector2.ONE * normal_scale
		poison_indicator.position = normal_counter_pos.position


func eat_and_free_food() -> void:
	if dead:
		food_this_round.queue_free()
		food_this_round = null
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
	if not is_seating_next_to_hated:
		current_poison += potential_love_multiplier * food_this_round.poison_present.get(creature_type, 0)
		last_drink_eaten = food_this_round.single_drink_present
	
	
	food_this_round.queue_free()
	food_this_round = null
 

func dying_check() -> bool:
	if dead:
		return false
	if current_poison >= max_poison:
		dead = true
		upon_death_ability()
		sprite_2d.texture = dead_textures_per_id[this_instance_id]
		return true
	return false


func killing_you_probability_check() -> bool:
	if dead or current_poison == 0:
		return false
	var did_hit_you = await check_bar.run_check(current_poison, max_poison, percentage_probability_mult_kill_you)
	return did_hit_you


func _ready() -> void:
	_check_exports()
	_set_name_and_texture()
	
	add_to_group("customers")


func _check_exports() -> void:
	var conditions : Array [bool] = []
	conditions.push_back(creature_type != Creatures.NONE)
	conditions.push_back(max_poison != MAX_POISON_NOT_SET)
	conditions.push_back(tool_tip_area != null)
	conditions.push_back(collider_of_tool_tip != null)
	conditions.push_back(poison_indicator != null)
	conditions.push_back(sprite_2d != null)
	conditions.push_back(on_list_counter_marker != null)
	conditions.push_back(normal_counter_pos != null)	
	conditions.push_back(names_per_id.size() > 0 and names_per_id.size() == alive_textures_per_id.size() \
	and alive_textures_per_id.size() == dead_textures_per_id.size())
	
	for cond in conditions:
		assert(cond, "Not all necessary export varibales of the customer parent class where set in the editor")


func tips(amount : int)-> void:
	gives_tip.emit(amount)
	return


func _set_name_and_texture() -> void:
	this_instance_id = id_for_names_and_textures
	id_for_names_and_textures = (id_for_names_and_textures+1) % names_per_id.size()
	customer_name = names_per_id[this_instance_id]
	sprite_2d.texture = alive_textures_per_id[this_instance_id]


func _process(_delta: float) -> void:
	tool_tip_area.change_displayed_text(_get_updated_tool_tip_text())
	poison_indicator.set_poison_indicator(current_poison, max_poison, dead)


#region func _get_updated_tool_tip_text() -> String:
func _get_updated_tool_tip_text() -> String:
	var identity_part = "[center][b]" + customer_name + "[/b][/center]"
	if dead:
		var gravestone_path = "res://art/enviroment/gravestone good.png"
		identity_part = "[center][img=64]"+gravestone_path+"[/img][b][color=#8a8a8a] "+customer_name+" [/color][/b][img=64]"+gravestone_path+"[/img][/center]"
	
	var type_description_part : String = creature_type_description_BBCode[creature_type]
	
	var lover_part := ""
	if is_lover:
		lover_part = "\nwhile sitting next to [color=#6bff95]" + loved_customer.customer_name + "[/color] : will [color=#6bff95]eat double poison.[/color]\n"
	
	var hater_part := ""
	if is_hater:
		hater_part = "\nwhile sitting next to [color=#ff6b6b]" + hated_customer.customer_name + "[/color] : will [color=#ff6b6b]not eat or drink.[/color]\n"
	
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












	
