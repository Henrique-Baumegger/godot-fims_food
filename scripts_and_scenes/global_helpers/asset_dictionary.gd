class_name AssetDictionary
extends Node

const scenes: Dictionary[String, PackedScene] = {
	
}

const sounds: Dictionary[String, AudioStream] = {
	
}


const instantiables: Dictionary[String, PackedScene] = {
	"food": preload("res://scripts_and_scenes/food/food.tscn"),
	"vampire": preload("res://scripts_and_scenes/customer/vampire.tscn"),
	"skeleton":preload("res://scripts_and_scenes/customer/skeleton.tscn")
	}

const customer_types : Array[String] = ["vampire", "skeleton"]

static func instantiate_random_customers(n: int) -> Array[Customer]:
	var result: Array[Customer] = []
	for i in range(n):
		var random_pick = customer_types.pick_random()
		result.append(instantiate_object(random_pick))
	return result



static func instantiate_object(object_name: String) -> Node2D:
	return instantiables[object_name].instantiate()
