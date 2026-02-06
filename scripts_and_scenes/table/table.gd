extends Node2D
class_name Table


var list_of_foods_this_round : Array[Food]
var clients_of_the_day : Array[Customer]
var client_positions_of_this_round : Array[Customer]
var table_size = 5

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


func assign_food() -> void:
	for i in range(table_size):
		client_positions_of_this_round[i].food_this_round = list_of_foods_this_round[i]


func start_day() -> void:
	new_set_of_customers()


func finish_day() -> void:
	delete_current_customers()

func start_round() -> void:
	new_round_of_food()
	shuffle_customers()


func new_round_of_food() -> void:
	var food_markers: Array[Marker2D] = [
		food_1_position,
		food_2_position,
		food_3_position,
		food_4_position,
		food_5_position
	]
	
	for f in list_of_foods_this_round:
		f.queue_free()
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






	
