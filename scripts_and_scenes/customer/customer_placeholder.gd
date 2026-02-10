@tool
extends Node2D


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	warnings.append("Replace this script by a custom customer.gd inherited script!")
	return warnings
