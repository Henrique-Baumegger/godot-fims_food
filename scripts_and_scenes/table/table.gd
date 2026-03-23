## LIFECYCLE methods:
## start_day()
## start_round()
## move_to_drink_phase()
## end_round()
## end_day() -> bool

## other useful INTERFACE:
## signal player_is_hitted
## signal recive_tip(amount)

extends Node2D
class_name Table


signal player_is_hitted
signal recive_tip(amount)

@export var table_size : int = 2 ## {2, 3, 4, 5, 6}

@export var food_markers : Array [Marker2D] 
@export var customers_on_table_markers : Array [Marker2D]


var customers_on_list_markers : Array [Marker2D]

var clients_of_the_day : Array[Customer]
var client_positions_of_this_round : Array[Customer]
var list_of_foods_this_round : Array[Food]


@onready var customer_list: Node2D = $CustomerList
@onready var label: Label = $CustomerList/Label
@onready var list_position_1: Marker2D = $CustomerList/ListPosition1
@onready var list_position_2: Marker2D = $CustomerList/ListPosition2
@onready var list_position_3: Marker2D = $CustomerList/ListPosition3
@onready var list_position_4: Marker2D = $CustomerList/ListPosition4
@onready var list_position_5: Marker2D = $CustomerList/ListPosition5
@onready var list_position_6: Marker2D = $CustomerList/ListPosition6


func start_day() -> void:
	_new_set_of_customers()
	_handle_list(true)
	for c in clients_of_the_day:
		c.start_of_day_ability()


func start_round() -> void:
	_handle_list(true)
	_new_round_of_food()
	for c in client_positions_of_this_round:
		c.start_of_round_ability()


func move_to_drink_phase() -> void:
	_sit_customers()
	_assign_food()
	_handle_list(false)


func end_round() -> void:
	for c in client_positions_of_this_round:
		c.eat_and_free_food()
	for c in client_positions_of_this_round:
		c.after_eating_ability()
	for c in client_positions_of_this_round:
		c.dying_check()
	for c in client_positions_of_this_round:
		var did_hit_you = await c.hitting_you_probability_check()
		if did_hit_you:
			player_is_hitted.emit()
	for c in client_positions_of_this_round:
		c.end_of_round_ability()


func end_day() -> bool:
	for c in client_positions_of_this_round:
		c.end_of_day_ability()
	
	var you_killed_them_all = true
	for c in clients_of_the_day:
		if not c.dead:
			you_killed_them_all = false
	
	_delete_current_customers()
	return you_killed_them_all


func _ready() -> void:
	customers_on_list_markers = [
		list_position_1,
		list_position_2,
		list_position_3,
		list_position_4,
		list_position_5,
		list_position_6
	]
	
	assert(food_markers.size() == customers_on_table_markers.size(), "food_markers and customers_on_table_markers exports must have same size")
	assert(food_markers.size() == table_size, "table size and array sizes must match")


func _new_round_of_food() -> void: #
	list_of_foods_this_round.clear()
	for i in range(table_size):
		var new_food = AssetDictionary.instantiate_general_object("food")
		new_food.position = food_markers[i].position
		add_child(new_food)
		list_of_foods_this_round.append(new_food)


func _assign_food() -> void: #
	for i in range(table_size):
		client_positions_of_this_round[i].give_food(list_of_foods_this_round[i]) 


func _new_set_of_customers() -> void: #
	var ordered_customer_containers : Array [CustomerContainer] = AssetDictionary.instantiate_customer_containers_in_order(table_size)
	for cc in ordered_customer_containers:
		add_child(cc)
		clients_of_the_day.append(cc.get_customer())
	clients_of_the_day.shuffle()
	client_positions_of_this_round = clients_of_the_day.duplicate()
	client_positions_of_this_round.shuffle()
	
	for cust in clients_of_the_day:
		cust.gives_tip.connect(recive_tip.emit)
	
	var treshold_for_love_relations = 3
	var treshold_for_hate_relations = 4
	if table_size >= treshold_for_love_relations:
		clients_of_the_day[0].set_up_relations(clients_of_the_day[1], null)
		clients_of_the_day[1].set_up_relations(clients_of_the_day[0], null)
	if table_size >= treshold_for_hate_relations:
		clients_of_the_day[2].set_up_relations(null, clients_of_the_day[3])
		clients_of_the_day[3].set_up_relations(null, clients_of_the_day[2])


func _sit_customers() -> void: #
	var not_allocated : Array [Customer] = client_positions_of_this_round.duplicate()
	var new_positions : Array [Customer] = []
	new_positions.resize(table_size)
	
	for i in range(table_size):
		var drink : Food.Drinks = client_positions_of_this_round[i].get_and_delete_last_drink_eaten()
		if drink != Food.Drinks.NONE:
			new_positions[posmod(i + Food.drink_to_offset[drink], table_size)] = client_positions_of_this_round[i] 
			# If 2 customers have the same seat preference, the customer to the right will overwritte the one on the left
	
	for i in range(table_size):
		if new_positions.has(client_positions_of_this_round[i]):
			not_allocated.erase(client_positions_of_this_round[i])
	
	for i in range(table_size):
		if new_positions[i] == null:
			var random_c = not_allocated.pick_random()
			new_positions[i] = random_c
			not_allocated.erase(random_c)
	
	client_positions_of_this_round = new_positions
	
	
	for i in range(table_size):
		client_positions_of_this_round[i].position = customers_on_table_markers[i].position
	
	client_positions_of_this_round[0].right_customer = client_positions_of_this_round[1]
	client_positions_of_this_round[table_size-1].left_customer = client_positions_of_this_round[table_size-2]
	for i in range(1, table_size-1):
		client_positions_of_this_round[i].right_customer = client_positions_of_this_round[i+1]
		client_positions_of_this_round[i].left_customer = client_positions_of_this_round[i-1]


func _delete_current_customers() -> void:
	for c in clients_of_the_day:
		c.queue_free()
	clients_of_the_day.clear()
	client_positions_of_this_round.clear()


func _handle_list(put_on_list: bool) -> void:
	customer_list.visible = put_on_list
	
	if put_on_list:
		for i in range(table_size):
			clients_of_the_day[i].global_position = customers_on_list_markers[i].global_position
			clients_of_the_day[i].list_format(true)
	else:
		for c: Customer in clients_of_the_day:
			c.list_format(false)









	
