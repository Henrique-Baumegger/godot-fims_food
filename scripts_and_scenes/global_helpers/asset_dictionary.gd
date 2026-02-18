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


static func instantiate_random_customers_container(n: int) -> Array[CustomerContainer]:
	var customer_keys : Array [Customer.Creatures] = customer_containers_instantiables.keys()
	var result: Array[CustomerContainer] = []
	for i in range(n):
		var random_pick : PackedScene = customer_containers_instantiables[customer_keys.pick_random()]
		result.append(random_pick.instantiate())
	return result


static func instantiate_general_object(object_name: Variant) -> Node2D:
	return general_instantiables[object_name].instantiate()
