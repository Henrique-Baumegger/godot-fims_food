extends Node
class_name PersistentAccrossGameLoops


@onready var ingredients_manager: IngredientsManager = $IngredientsManager
@onready var life_manager_wrapper: PanelContainer = $LifeManagerWrapper
@onready var money_manager_wrapper: PanelContainer = $MoneyManagerWrapper
@onready var continue_button: Button = $ContinueButton
@onready var day_counter_wrapper: PanelContainer = $DayCounterWrapper


func get_button_signal()-> Signal:
	return continue_button.pressed


func toggle_visibility(on:bool) -> void:
	ingredients_manager.visible = on
	life_manager_wrapper.visible = on
	money_manager_wrapper.visible = on
	day_counter_wrapper.visible = on
	continue_button.visible = on
	if on:
		continue_button.modulate.a = 1
	else:
		continue_button.modulate.a = 0
	continue_button.disabled = not on


func set_button_text(text_to_write : String) -> void:
	continue_button.text = text_to_write


func fade_button_in(time:float, delay:float) -> void:
	continue_button.disabled = false
	continue_button.visible = true
	var tw : Tween = create_tween()
	tw.tween_interval(delay)
	tw.tween_property(continue_button, "modulate:a", 1, time)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	#Equivalent to:
	#tw.tween_property(continue_button, "modulate:a", 1, time).set_delay(delay)
