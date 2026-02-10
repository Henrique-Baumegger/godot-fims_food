extends Customer
class_name Vampire


var poisonless_tip_amount = 5


func start_of_round_ability() ->void:
	pass


func end_of_round_ability() ->void:
	pass


func after_eating_ability() -> void:
	if dead:
		return
	if current_poison == 0:
		gives_tip.emit(poisonless_tip_amount)


func start_of_day_ability() ->void:
	pass


func end_of_day_ability() ->void:
	pass
