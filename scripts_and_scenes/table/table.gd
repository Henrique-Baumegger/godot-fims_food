extends Node2D
class_name Table


var table_size = 5
var list_of_foods_this_round : Array[Food]
var clients_of_the_day : Array[Customer]
var client_positions_of_this_round : Array[Customer]

@onready var customer_list: Node2D = $CustomerList
@onready var list_position_1: Marker2D = $CustomerList/list_position1
@onready var list_position_2: Marker2D = $CustomerList/list_position2
@onready var list_position_3: Marker2D = $CustomerList/list_position3
@onready var list_position_4: Marker2D = $CustomerList/list_position4
@onready var list_position_5: Marker2D = $CustomerList/list_position5
@onready var label: Label = $CustomerList/Label


@onready var food_1_position: Marker2D = $FoodPositions/Food1Position
@onready var food_2_position: Marker2D = $FoodPositions/Food2Position
@onready var food_3_position: Marker2D = $FoodPositions/Food3Position
@onready var food_4_position: Marker2D = $FoodPositions/Food4Position
@onready var food_5_position: Marker2D = $FoodPositions/Food5Position

@onready var customer_1_position: Marker2D = $CustomerPositions/Customer1Position
@onready var customer_2_position: Marker2D = $CustomerPositions/Customer2Position
@onready var customer_3_position: Marker2D = $CustomerPositions/Customer3Position
@onready var customer_4_position: Marker2D = $CustomerPositions/Customer4Position
@onready var customer_5_position: Marker2D = $CustomerPositions/Customer5Position


func start_day() -> void:
	new_set_of_customers()


func start_round() -> void:
	handle_list(true)
	new_round_of_food()


func clients_go_to_table() -> void:
	handle_list(false)
	shuffle_customers()


func assign_food() -> void:
	for i in range(table_size):
		client_positions_of_this_round[i].food_this_round = list_of_foods_this_round[i]


func finish_day() -> void:
	delete_current_customers()


func new_round_of_food() -> void:
	var food_markers: Array[Marker2D] = [
		food_1_position,
		food_2_position,
		food_3_position,
		food_4_position,
		food_5_position
	]
	
	list_of_foods_this_round.clear()
	
	for i in range(table_size):
		var new_food = AssetDictionary.instantiate_object("food")
		new_food.position = food_markers[i].position
		add_child(new_food)
		list_of_foods_this_round.append(new_food)


func delete_current_customers() -> void:
	for c in clients_of_the_day:
		c.queue_free()


func new_set_of_customers() -> void:
	clients_of_the_day = AssetDictionary.instantiate_random_customers(table_size)
	for cust in clients_of_the_day:
		add_child(cust)
	set_new_customer_relations()


func shuffle_customers() -> void:
	client_positions_of_this_round = clients_of_the_day.duplicate()
	client_positions_of_this_round.shuffle()
	var customer_markers: Array[Marker2D] = [
		customer_1_position,
		customer_2_position,
		customer_3_position,
		customer_4_position,
		customer_5_position
	]
	for i in range(table_size):
		var c: Customer = client_positions_of_this_round[i]
		c.position = customer_markers[i].position
	
	set_left_and_rights_of_customers()


func set_left_and_rights_of_customers() -> void:
	client_positions_of_this_round[0].right_customer = client_positions_of_this_round[1]
	client_positions_of_this_round[4].left_customer = client_positions_of_this_round[3]
	for i in range(1, table_size-1):
		client_positions_of_this_round[i].right_customer = client_positions_of_this_round[i-1]
		client_positions_of_this_round[i].left_customer = client_positions_of_this_round[i+1]


func set_new_customer_relations() -> void:
	clients_of_the_day[0].is_lover = true
	clients_of_the_day[1].is_lover = true
	clients_of_the_day[0].loved_name = clients_of_the_day[1].identity_name
	clients_of_the_day[1].loved_name = clients_of_the_day[0].identity_name
	clients_of_the_day[2].is_hater = true
	clients_of_the_day[3].is_hater = true
	clients_of_the_day[2].hated_name = clients_of_the_day[3].identity_name
	clients_of_the_day[3].hated_name = clients_of_the_day[2].identity_name


func handle_list(put_on_list: bool) -> void:
	customer_list.visible = put_on_list
	var list_markers: Array[Marker2D] = [
		list_position_1,
		list_position_2,
		list_position_3,
		list_position_4,
		list_position_5
	]
	if put_on_list:
		for i in range(table_size):
			var c: Customer = clients_of_the_day[i]
			c.position = list_markers[i].position
			c.list_format(true)
	else:
		for c: Customer in clients_of_the_day:
			c.list_format(false)









	
