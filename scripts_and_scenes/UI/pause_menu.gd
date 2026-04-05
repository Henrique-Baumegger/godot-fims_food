extends Control
class_name PauseMenu


var is_paused : bool = false
var is_fullscreen = false

@onready var speed_1: Button = $PanelContainer/MarginContainer/AllOptions/GameSpeedStuff/GameSpeeds/speed1
@onready var speed_2: Button = $PanelContainer/MarginContainer/AllOptions/GameSpeedStuff/GameSpeeds/speed2
@onready var speed_3: Button = $PanelContainer/MarginContainer/AllOptions/GameSpeedStuff/GameSpeeds/speed3
@onready var speed_4: Button = $PanelContainer/MarginContainer/AllOptions/GameSpeedStuff/GameSpeeds/speed4
@onready var speed_5: Button = $PanelContainer/MarginContainer/AllOptions/GameSpeedStuff/GameSpeeds/speed5
@onready var speed_6: Button = $PanelContainer/MarginContainer/AllOptions/GameSpeedStuff/GameSpeeds/speed6
@onready var speed_7: Button = $PanelContainer/MarginContainer/AllOptions/GameSpeedStuff/GameSpeeds/speed7


func toggle_the_menu() -> void:
	if not is_paused:
		is_paused = true
		get_tree().paused = true
		visible = true
	else:
		is_paused = false
		get_tree().paused = false
		visible = false


func _ready() -> void:
	speed_2.disabled = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc_key"):
		toggle_the_menu()


func _enable_all_buttons() -> void:
	speed_1.disabled = false
	speed_2.disabled = false
	speed_3.disabled = false
	speed_4.disabled = false
	speed_5.disabled = false
	speed_6.disabled = false
	speed_7.disabled = false


func _on_speed_1_pressed() -> void:
	_enable_all_buttons()
	Engine.time_scale = 0.5
	speed_1.disabled = true
	toggle_the_menu()


func _on_speed_2_pressed() -> void:
	_enable_all_buttons()
	Engine.time_scale = 1
	speed_2.disabled = true
	toggle_the_menu()


func _on_speed_3_pressed() -> void:
	_enable_all_buttons()
	Engine.time_scale = 1.5
	speed_3.disabled = true
	toggle_the_menu()


func _on_speed_4_pressed() -> void:
	_enable_all_buttons()
	Engine.time_scale = 2
	speed_4.disabled = true
	toggle_the_menu()


func _on_speed_5_pressed() -> void:
	_enable_all_buttons()
	Engine.time_scale = 3
	speed_5.disabled = true
	toggle_the_menu()


func _on_speed_6_pressed() -> void:
	_enable_all_buttons()
	Engine.time_scale = 4
	speed_6.disabled = true
	toggle_the_menu()


func _on_speed_7_pressed() -> void:
	_enable_all_buttons()
	Engine.time_scale = 8
	speed_7.disabled = true
	toggle_the_menu()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_toggle_fullscreen_pressed() -> void:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
