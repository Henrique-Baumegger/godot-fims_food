## LIFECYCLE methods: (owner should call these stages in a consistent order)
##   start_of_day_ability() 
##   start_of_round_ability() 
##   eat_and_free_food() 
##   after_eating_ability()
##   dying_check()
##   hitting_you_probability_check()
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
	Creatures.GHOST : "[b]GHOST[/b] - tips 3 doubloons on round end if dead.",
	Creatures.SKELETON : "[b]SKELETON[/b] — doubles its poison after eating (or refusing to eat). tips 6 upon death",
	Creatures.VAMPIRE : "[b]VAMPIRE[/b] - if alive, tips double its poison at round start."
	}

const MAX_POISON_NOT_SET : int = -1
const percentage_probability_mult_hit_you : float = 1

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

@onready var visuals_wrapper: Node2D = $VisualsWrapper
@onready var alive_sprite: Sprite2D = $VisualsWrapper/AliveSprite
@onready var dead_sprite: Sprite2D = $VisualsWrapper/DeadSprite
@onready var adding_text: RichTextLabel = $VisualsWrapper/AddingText

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
		visuals_wrapper.scale = Vector2.ONE * list_scale
		poison_indicator.position = on_list_counter_marker.position
	else:
		collider_of_tool_tip.scale = Vector2.ONE * normal_scale
		visuals_wrapper.scale = Vector2.ONE * normal_scale
		poison_indicator.position = normal_counter_pos.position


func eat_and_free_food() -> void:
	var is_seating_next_to_hated : bool = is_hater and \
	((left_customer != null and left_customer == hated_customer )or \
	(right_customer != null and right_customer == hated_customer))
	
	var is_seating_next_to_loved : bool = is_lover and \
	((left_customer != null and left_customer == loved_customer )or \
	(right_customer != null and right_customer == loved_customer))
	
	if dead or is_seating_next_to_hated:
		await food_this_round.slowely_dissapear()
		food_this_round = null
		return
	
	var potential_love_multiplier = 1
	if is_seating_next_to_loved:
		potential_love_multiplier = 2
	current_poison += potential_love_multiplier * food_this_round.poison_present.get(creature_type, 0)
	last_drink_eaten = food_this_round.single_drink_present
	
	
	await food_this_round.be_eaten()
	food_this_round = null
 

func dying_check() -> bool:
	if dead:
		return false
	if current_poison >= max_poison:
		await _die()
		return true
	return false


func hitting_you_probability_check() -> bool:
	if dead or current_poison == 0:
		return false
	var did_hit_you = await check_bar.run_hit_check(current_poison, max_poison, percentage_probability_mult_hit_you)
	return did_hit_you


func tips(amount : int)-> void:
	gives_tip.emit(amount)
	
	var lenght : float = 0.85
	adding_text.visible = true
	var original_y = -85.0
	var target_y = -144
	adding_text.position.y = original_y
	adding_text.modulate.a = 1
	adding_text.text = "+[img=36x36]res://art/items/coin_skull.png[/img]%d" % amount
	
	var tween = self.create_tween()
	tween.set_parallel(true)
	tween.tween_property(adding_text, "position:y", target_y, lenght)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(adding_text, "modulate:a", 0, lenght)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_QUART)
	return


func _ready() -> void:
	_check_exports()
	_set_name_and_texture()


func _check_exports() -> void:
	var conditions : Array [bool] = []
	conditions.push_back(creature_type != Creatures.NONE)
	conditions.push_back(max_poison != MAX_POISON_NOT_SET)
	conditions.push_back(tool_tip_area != null)
	conditions.push_back(collider_of_tool_tip != null)
	conditions.push_back(poison_indicator != null)
	conditions.push_back(alive_sprite != null)
	conditions.push_back(on_list_counter_marker != null)
	conditions.push_back(normal_counter_pos != null)	
	conditions.push_back(names_per_id.size() > 0 and names_per_id.size() == alive_textures_per_id.size() \
	and alive_textures_per_id.size() == dead_textures_per_id.size())
	
	for cond in conditions:
		assert(cond, "Not all necessary export varibales of the customer parent class where set in the editor")


func _die()-> void:
	dead = true
	upon_death_ability()
	
	dead_sprite.visible = true
	dead_sprite.modulate.a = 0.0
	
	var tween = create_tween().set_parallel(true)
	
	# Alive sprite: fade out + shift to a dark purple tint
	tween.tween_property(alive_sprite, "modulate", Color(0.45, 0.2, 0.55, 0.0), 0.8)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	# Alive sprite: slight shrink as life drains
	tween.tween_property(alive_sprite, "scale", alive_sprite.scale * 0.9, 0.8)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	# Dead sprite: fade in with a slight delay so it emerges from the purple
	tween.tween_property(dead_sprite, "modulate:a", 1.0, 0.6)\
		.set_delay(0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	# A little "soul leaving the body" float upward then settle back
	var orig_y = position.y
	tween.tween_property(self, "position:y", orig_y - 6.0, 0.4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(self, "position:y", orig_y, 0.4)\
		.set_delay(0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	return


func _set_name_and_texture() -> void:
	this_instance_id = id_for_names_and_textures
	id_for_names_and_textures = (id_for_names_and_textures+1) % names_per_id.size()
	customer_name = names_per_id[this_instance_id]
	alive_sprite.texture = alive_textures_per_id[this_instance_id]
	dead_sprite.texture = dead_textures_per_id[this_instance_id]


func _process(_delta: float) -> void:
	tool_tip_area.change_displayed_text(_get_updated_tool_tip_text())
	poison_indicator.set_poison_indicator(current_poison, max_poison, dead)


#region func _get_updated_tool_tip_text() -> String:
func _get_updated_tool_tip_text() -> String:
	var identity_part = "[center][b]" + customer_name + "[/b][/center]"
	if dead:
		const gravestone_img_path = "res://art/enviroment/gravestone good.png"
		identity_part = "[center][img=64]"+gravestone_img_path+"[/img][b][color=#8a8a8a] "+customer_name+" [/color][/b][img=64]"+gravestone_img_path+"[/img][/center]"
	
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












	
