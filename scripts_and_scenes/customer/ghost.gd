extends Customer
class_name Ghost


const dead_tip_amount = 3


func start_of_round_ability() ->void:
	pass


func end_of_round_ability() ->void:
	if dead:
		tips(dead_tip_amount)


func after_eating_ability() ->void:
	pass


func start_of_day_ability() ->void:
	pass


func end_of_day_ability() ->void:
	pass


func upon_death_ability() -> void:
	pass
