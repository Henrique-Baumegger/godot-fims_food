class_name AssetDictionary
extends Node


const general_scenes: Dictionary[String, PackedScene] = {
	
}

const sounds: Dictionary[String, AudioStream] = {
	
}

const general_instantiables: Dictionary[String, PackedScene] = {
	"food": preload("res://scripts_and_scenes/food/food.tscn"),
	}

const customer_instantiables: Dictionary[Customer.Creatures, PackedScene] = {
	Customer.Creatures.VAMPIRE: preload("res://scripts_and_scenes/customer/vampire.tscn"),
	Customer.Creatures.SKELETON: preload("res://scripts_and_scenes/customer/skeleton.tscn"),
	Customer.Creatures.GHOST: preload("res://scripts_and_scenes/customer/ghost.tscn")
	}


static func instantiate_random_customers(n: int) -> Array[Customer]:
	var customer_keys : Array [Customer.Creatures] = customer_instantiables.keys()
	var result: Array[Customer] = []
	for i in range(n):
		var random_pick : PackedScene = customer_instantiables[customer_keys.pick_random()]
		result.append(random_pick.instantiate())
	return result


static func instantiate_general_object(object_name: Variant) -> Node2D:
	return general_instantiables[object_name].instantiate()
