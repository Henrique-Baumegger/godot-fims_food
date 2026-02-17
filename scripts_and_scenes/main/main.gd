extends Node2D

const day_size = 3

var pre_sit_phase : bool = true
var current_round = 0
var money = 0
var wait_time : float = 0.6

@onready var next_round_button: Button = $NextRoundButton
@onready var money_label: Label = $MoneyLabel
@onready var round_label: Label = $RoundLabel
@onready var you_die_label: Label = $YouDieLabel
@onready var end_of_day_lose: Label = $EndOfDayLose

@onready var _4_seat_table: VariableSeatAmountTableContainer = $"4SeatTable"

@onready var onion: Ingredient = $Onion
@onready var salt: Ingredient = $Salt
@onready var silver: Ingredient = $Silver


func _ready() -> void:
	var table : Table = _4_seat_table.get_table()
	table.player_is_killed.connect(_on_kills_you)
	table.recive_tip.connect(_on_recives_tip)
	
	table.start_day()
	table.start_round()
	next_round_button.text = "Sit custommers"


func _on_recives_tip(amount:int) -> void:
	money += amount
	money_label.text = str(money)+" doubloons"


func _on_kills_you()-> void:
	you_die_label.visible = true


func _on_next_round_pressed() -> void:
	if pre_sit_phase:
		pre_sit_press()
	else: 
		pos_sit_press()
	pre_sit_phase = not pre_sit_phase


func pre_sit_press() -> void:
	next_round_button.disabled = true
	var table : Table = _4_seat_table.get_table()
	
	onion.toggle_warm_ingredients_selectability(false)
	salt.toggle_warm_ingredients_selectability(false)
	silver.toggle_warm_ingredients_selectability(false)
	
	
	table.move_to_drink_phase()
	await get_tree().create_timer(wait_time).timeout
	
	if current_round == day_size-1:
		next_round_button.text = "Finish day"
	else:
		next_round_button.text = "Finish meal"
	
	next_round_button.disabled = false


func pos_sit_press() -> void:
	next_round_button.disabled = true
	var table : Table = _4_seat_table.get_table()
	
	onion.toggle_warm_ingredients_selectability(true)
	salt.toggle_warm_ingredients_selectability(true)
	silver.toggle_warm_ingredients_selectability(true)
	
	table.end_round()
	await get_tree().create_timer(wait_time).timeout
	
	if current_round == day_size-1:
		var we_succeded : bool = table.end_day()
		await get_tree().create_timer(wait_time).timeout
		
		if not we_succeded:
			end_of_day_lose.visible = true
		
		table.start_day()
		await get_tree().create_timer(wait_time).timeout
	
	table.start_round()
	await get_tree().create_timer(wait_time).timeout
	
	next_round_button.text = "Sit custommers"
	current_round = (current_round+1)% day_size
	round_label.text = str(current_round+1) + "/" + str(day_size)+ " meals"
	
	next_round_button.disabled = false
