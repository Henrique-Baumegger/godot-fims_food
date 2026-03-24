extends Node2D
class_name TableGameLoop

const day_size = 3

@export var variable_seat_table: VariableSeatAmountTableContainer = null

var pre_sit_phase : bool = true
var current_round = 0
var wait_time : float = 0.6

var ingredients_manager : IngredientsManager = null
var money_manager: MoneyManager = null
var life_manager: LifeManager = null
var continue_button: Button = null

@onready var round_label: Label = $UI/PanelContainer/MarginContainer/RoundLabel
@onready var damage_effect: DamageEffect = $UI/DamageEffect
@onready var you_die_label: Label = $UI/YouDieLabel
@onready var end_of_day_lose: Label = $UI/EndOfDayLose

@onready var table: Table = variable_seat_table.get_table()


func _ready() -> void:
	ingredients_manager = get_tree().get_first_node_in_group("ingredients_manager")
	money_manager = get_tree().get_first_node_in_group("money_manager")
	life_manager = get_tree().get_first_node_in_group("life_manager")
	continue_button = get_tree().get_first_node_in_group("continue_button")
	
	assert(ingredients_manager != null, "The scene tree must always have a IngredientsManager")
	assert(money_manager != null, "The scene tree must always have a MoneyManager")	
	assert(life_manager != null, "The scene tree must always have a LifeManager")
	assert(continue_button != null, "The scene tree must always have a continue_button")
	
	assert(variable_seat_table != null, "We need a VariableSeatAmountTableContainer")
	
	continue_button.pressed.connect(_on_continue_button_pressed)
	
	variable_seat_table.position = Vector2(966, 546)
	table.player_is_hitted.connect(_on_hits_you)
	table.recive_tip.connect(_on_recives_tip)
	
	table.start_day()
	table.start_round()
	continue_button.text = "Sit custommers"
	round_label.text = "meal " + str(current_round+1) + "/" + str(day_size)


func _on_recives_tip(amount:int) -> void:
	money_manager.add_money(amount)


func _on_hits_you()-> void:
	damage_effect.play_damage_animation()
	var player_life_went_to_zero = life_manager.add_life_and_return_is_dead(-1)
	if player_life_went_to_zero:
		you_die_label.visible = true


func _on_continue_button_pressed() -> void:
	if pre_sit_phase:
		pre_sit_press()
	else: 
		pos_sit_press()
	pre_sit_phase = not pre_sit_phase


func pre_sit_press() -> void:
	continue_button.disabled = true
	continue_button.text = "..."
	
	var last_round : bool = current_round == day_size-1
	
	ingredients_manager.toggle_warm_ingredients_selectability(false)
	
	table.move_to_drink_phase()
	await get_tree().create_timer(wait_time).timeout
	
	if last_round:
		continue_button.text = "Finish day"
	else:
		continue_button.text = "Finish meal"
	
	continue_button.disabled = false


func pos_sit_press() -> void:
	continue_button.disabled = true
	var last_round : bool = current_round == day_size-1
	
	current_round = (current_round+1) % day_size
	continue_button.text = "..."
	round_label.text = "meal .../" + str(day_size)
	ingredients_manager.toggle_warm_ingredients_selectability(true)
	
	await table.end_round()
	await get_tree().create_timer(wait_time).timeout
	
	if last_round:
		var we_succeded : bool = table.end_day()
		await get_tree().create_timer(wait_time).timeout
		
		if not we_succeded:
			end_of_day_lose.visible = true
		
		table.start_day()
		await get_tree().create_timer(wait_time).timeout
	
	table.start_round()
	await get_tree().create_timer(wait_time).timeout
	
	continue_button.text = "Sit custommers"
	round_label.text = "meal " + str(current_round+1) + "/" + str(day_size)
	
	continue_button.disabled = false
