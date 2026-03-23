extends PanelContainer
class_name PoisonIndicator 

const gravestone_path = "res://art/enviroment/gravestone good.png"

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel


func set_poison_indicator(current_poison:int, max_poison:int, is_dead:bool) -> void:
	if not is_dead:
		rich_text_label.text = "[center][color=#b36bff]"+str(current_poison) + "[/color] / " + str(max_poison)+"[/center]"
	elif is_dead:
		rich_text_label.text = "[center][img=64]"+gravestone_path+"[/img]"



func make_red() -> void:
	var style : StyleBox = get_theme_stylebox("panel").duplicate()
	style.bg_color = Color(0.632, 0.172, 0.168, 0.7)
	add_theme_stylebox_override("panel", style)


func make_green() -> void:
	var style : StyleBox = get_theme_stylebox("panel").duplicate()
	style.bg_color = Color(0.188, 0.51, 0.129, 0.702)
	add_theme_stylebox_override("panel", style)
