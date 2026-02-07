extends Node2D

var current_round = 1
var money = 0
var time_between_rounds : float = 1
var time_between_days: float = 2


@onready var money_label: Label = $MoneyLabel
@onready var round_label: Label = $RoundLabel
@onready var you_die_label: Label = $YouDieLabel
@onready var next_round: Button = $NextRound
@onready var end_of_day_lose: Label = $EndOfDayLose

func _ready() -> void:
	
	get_tree().call_group("round_dependers", "start_day")
	get_tree().call_group("round_dependers", "start_round")
	make_connections()


func make_connections() -> void:
	var customers_in_scene : Array[Node] = get_tree().get_nodes_in_group("customers")
	for c in customers_in_scene:
		c.kills_you.connect(_on_kills_you)
		c.gives_tip.connect(_on_recives_tip)


func _on_recives_tip(amount:int) -> void:
	money += amount
	money_label.text = "doubloons "+ str(money)


func _on_kills_you()-> void:
	you_die_label.visible = true


func _on_next_round_pressed() -> void:
	var last_round : bool = current_round >= 3
	if last_round:
		get_tree().call_group("round_dependers", "assign_food")
		get_tree().call_group("round_dependers", "finish_round")
		lose_the_day_check()
		next_round.disabled = true
		await get_tree().create_timer(time_between_days).timeout
		get_tree().call_group("round_dependers", "finish_day")
		await get_tree().create_timer(time_between_days).timeout
		next_round.disabled = false
		get_tree().call_group("round_dependers", "start_day")
		get_tree().call_group("round_dependers", "start_round")
		current_round = 1
		make_connections()
	else:
		get_tree().call_group("round_dependers", "assign_food")
		get_tree().call_group("round_dependers", "finish_round")
		next_round.disabled = true
		await get_tree().create_timer(time_between_rounds).timeout
		next_round.disabled = false
		get_tree().call_group("round_dependers", "start_round")
		current_round += 1
	round_label.text = "Round: "+ str(current_round)


func lose_the_day_check() -> void: 
	var customers_in_scene : Array[Node] = get_tree().get_nodes_in_group("customers")
	for c in customers_in_scene:
		if not c.dead:
			end_of_day_lose.visible = true
