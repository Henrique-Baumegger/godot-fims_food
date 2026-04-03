extends Customer
class_name Vampire


func start_of_round_ability() ->void:
	if dead:
		return
	if current_poison != 0:
		tips(2*current_poison)


func end_of_round_ability() ->void:
	pass


func after_eating_ability() -> void:
	pass


func start_of_day_ability() ->void:
	pass


func end_of_day_ability() ->void:
	pass


func upon_death_ability() -> void:
	pass
