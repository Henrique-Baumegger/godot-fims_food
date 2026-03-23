extends Node2D
class_name TableGameLoop

const day_size = 3

@export var var_seat_table: VariableSeatAmountTableContainer

var pre_sit_phase : bool = true
var current_round = 0
var money = 0
var wait_time : float = 0.6
var ingredients_manager : IngredientsManager = null

@onready var life_manager: LifeManager = $LifeManager
@onready var damage_effect: DamageEffect = $CanvasLayer/DamageEffect

@onready var next_round_button: Button = $NextRoundButton
@onready var money_label: Label = $MoneyLabel
@onready var round_label: Label = $RoundLabel
@onready var you_die_label: Label = $YouDieLabel
@onready var end_of_day_lose: Label = $EndOfDayLose


func _ready() -> void:
	ingredients_manager = get_tree().get_first_node_in_group("ingredients_manager")
	assert(ingredients_manager != null, "The scene tree must always have a IngredientsManager")
	
	var_seat_table.position = Vector2(966, 546)
	var table : Table = var_seat_table.get_table()
	table.player_is_hitted.connect(_on_hits_you)
	table.recive_tip.connect(_on_recives_tip)
	
	table.start_day()
	table.start_round()
	next_round_button.text = "Sit custommers"
	round_label.text = str(current_round+1) + "/" + str(day_size)+ "\n meals"


func _on_recives_tip(amount:int) -> void:
	money += amount
	money_label.text = str(money)+" doubloons"


func _on_hits_you()-> void:
	damage_effect.play_damage_animation()
	var player_life_went_to_zero = life_manager.add_life_and_return_is_dead(-1)
	if player_life_went_to_zero:
		you_die_label.visible = true


func _on_next_round_pressed() -> void:
	if pre_sit_phase:
		pre_sit_press()
	else: 
		pos_sit_press()
	pre_sit_phase = not pre_sit_phase


func pre_sit_press() -> void:
	next_round_button.disabled = true
	
	var last_round : bool = current_round == day_size-1
	if last_round:
		next_round_button.text = "Finish day"
	else:
		next_round_button.text = "Finish meal"
	
	var table : Table = var_seat_table.get_table()
	
	ingredients_manager.toggle_warm_ingredients_selectability(false)
	
	table.move_to_drink_phase()
	await get_tree().create_timer(wait_time).timeout
	
	next_round_button.disabled = false


func pos_sit_press() -> void:
	next_round_button.disabled = true
	var last_round : bool = current_round == day_size-1
	
	next_round_button.text = "Sit custommers"
	current_round = (current_round+1) % day_size
	round_label.text = str(current_round+1) + "/" + str(day_size)+ "\n meals"
	
	var table : Table = var_seat_table.get_table()
	
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
	
	next_round_button.disabled = false
