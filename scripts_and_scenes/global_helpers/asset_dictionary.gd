class_name AssetDictionary
extends Node

const scenes: Dictionary[String, PackedScene] = {
	
}

const sounds: Dictionary[String, AudioStream] = {
	
}


const instantiables: Dictionary[String, PackedScene] = {
	#"frequent_impulse_ball": preload("res://scripts_and_scenes/ball_logic/frequent_impulse_ball.tscn"),
	}


static func instantiate_object(object_name: String) -> Node2D:
	return instantiables[object_name].instantiate()
