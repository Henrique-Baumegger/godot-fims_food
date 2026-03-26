extends RichTextLabel
class_name MoneyManager

const doubloon_img_path : String = "res://art/place_holder/placeholder_doubloon.png"

@export var money = 0


func get_money() -> int:
	return money


func set_money(new_amount : int) -> void:
	money = new_amount
	_update_visuals()
	return 


func add_money(amount : int) -> void:
	money = money + amount
	_update_visuals()
	return 


func _ready() -> void:
	_update_visuals()


func _update_visuals() -> void:
	text = "[img=98x98]"+doubloon_img_path+"[/img] "+str(money)










	
