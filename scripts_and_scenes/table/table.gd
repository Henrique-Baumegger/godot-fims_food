extends Node2D
class_name Table


@export var table_size : int = 2 ## {2, 3, 4, 5, 6}

@export var food_markers : Array [Marker2D] 
@export var customers_on_table_markers : Array [Marker2D]
@export var candle_markers : Array [Marker2D]

var customers_on_list_markers : Array [Marker2D]

var clients_of_the_day : Array[Customer]
var client_positions_of_this_round : Array[Customer]
var list_of_foods_this_round : Array[Food]

@onready var list: Node2D = $List
@onready var label: Label = $List/Label
@onready var list_position_1: Marker2D = $List/ListPosition1
@onready var list_position_2: Marker2D = $List/ListPosition2
@onready var list_position_3: Marker2D = $List/ListPosition3
@onready var list_position_4: Marker2D = $List/ListPosition4
@onready var list_position_5: Marker2D = $List/ListPosition5
@onready var list_position_6: Marker2D = $List/ListPosition6


func _ready() -> void:
	customers_on_list_markers = [
		list_position_1,
		list_position_2,
		list_position_3,
		list_position_4,
		list_position_5,
		list_position_6
	]


func _assign_food() -> void:
	for i in range(table_size):
		client_positions_of_this_round[i].food_this_round = list_of_foods_this_round[i]


func finish_day() -> void:
	delete_current_customers()


func new_round_of_food() -> void:
	list_of_foods_this_round.clear()
	for i in range(table_size):
		var new_food = AssetDictionary.instantiate_general_object("food")
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
	
	if put_on_list:
		for i in range(table_size):
			var c: Customer = clients_of_the_day[i]
			c.position = list_markers[i].position
			c.list_format(true)
	else:
		for c: Customer in clients_of_the_day:
			c.list_format(false)









	
