extends PanelContainer
class_name PoisonIndicator 

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

func set_poison_indicator(current_poison:int, max_poison:int, is_dead:bool) -> void:
	if not is_dead:
		rich_text_label.text = "[center][b][color=#b36bff]"+str(current_poison) + "[/color][/b] / " + str(max_poison)+"[/center]"
	elif is_dead:
		visible = false


func make_red() -> void:
	var style := get_theme_stylebox("panel").duplicate()
	style.bg_color = Color(0.4, 0.15, 0.15, 0.7)
	add_theme_stylebox_override("panel", style)



func make_green() -> void:
	var style := get_theme_stylebox("panel").duplicate()
	style.bg_color = Color(0.15, 0.4, 0.15, 0.7)
	add_theme_stylebox_override("panel", style)
