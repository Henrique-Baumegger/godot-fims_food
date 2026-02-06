extends PanelContainer
class_name PoisonIndicator 

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

func set_poison_indicator(current_poison:int, max_poison:int) -> void:
	rich_text_label.text = "[center][b][color=#b36bff]"+str(current_poison) + "[/color][/b] / " + str(max_poison)+"[/center]"
