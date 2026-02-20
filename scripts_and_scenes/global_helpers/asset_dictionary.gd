class_name AssetDictionary
extends Node


const general_instantiables: Dictionary[String, PackedScene] = {
	"food" : preload("res://scripts_and_scenes/food/food.tscn"),
	}

const customer_containers_instantiables: Dictionary[Customer.Creatures, PackedScene] = {
	Customer.Creatures.VAMPIRE : preload("res://scripts_and_scenes/customer/vampire.tscn"),
	Customer.Creatures.SKELETON : preload("res://scripts_and_scenes/customer/skeleton.tscn"),
	Customer.Creatures.GHOST : preload("res://scripts_and_scenes/customer/ghost.tscn")
	}

const table_instantiables : Dictionary[int , PackedScene] = {
	2 : preload("res://scripts_and_scenes/table/2_seat_table.tscn"),
	3 : preload("res://scripts_and_scenes/table/3_seat_table.tscn"),
	4 : preload("res://scripts_and_scenes/table/4_seat_table.tscn"),
	5 : preload("res://scripts_and_scenes/table/5_seat_table.tscn"),
	6 : preload("res://scripts_and_scenes/table/6_seat_table.tscn"),
}


static func instantiate_table_container(number_of_seats : int) ->VariableSeatAmountTableContainer:
	return table_instantiables[number_of_seats].instantiate()


## These customers containers need to be added to the scene tree in array order
## After that, they can be shuffled
static func instantiate_customer_containers_in_order(n:int) -> Array[CustomerContainer]:
	assert(n >= 0, "n must be non-negative")
	assert(n <= 15, "Maximum total is 15 (5 of each type)")
	var keys: Array[Customer.Creatures] = customer_containers_instantiables.keys()
	var counts : Dictionary[Customer.Creatures, int] = {}
	for key in keys:
		counts[key] = 0
	
	for i in range(n):
		var available := []
		for key in keys:
			if counts[key] < 5:
				available.append(key)
		
		var chosen = available.pick_random()
		counts[chosen] += 1
		
	var result: Array[CustomerContainer] = []
	for key in keys:
		for i in range(counts[key]):
			result.append(customer_containers_instantiables[key].instantiate())
	return result


static func instantiate_general_object(object_name: Variant) -> Node2D:
	return general_instantiables[object_name].instantiate()
