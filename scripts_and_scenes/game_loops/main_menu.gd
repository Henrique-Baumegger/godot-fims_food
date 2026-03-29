extends Node2D
class_name MainMenu

signal difficulty_signal(difficulty: Main.Difficulties)

@onready var mortal_button: Button = $MortalButton
@onready var grim_button: Button = $GrimButton
@onready var forsaken_button: Button = $ForsakenButton


func _on_mortal_button_pressed() -> void:
	difficulty_signal.emit(Main.Difficulties.MORTAL)


func _on_grim_button_pressed() -> void:
	difficulty_signal.emit(Main.Difficulties.GRIM)


func _on_forsaken_button_pressed() -> void:
	difficulty_signal.emit(Main.Difficulties.FORSAKEN)



	
