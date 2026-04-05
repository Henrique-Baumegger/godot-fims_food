extends Control
class_name PauseUI


@onready var pause_menu: PauseMenu = $PauseMenu


func _on_texture_button_pressed() -> void:
	pause_menu.toggle_the_menu()
