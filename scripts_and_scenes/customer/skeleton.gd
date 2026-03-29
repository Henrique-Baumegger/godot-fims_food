extends Customer
class_name Skeleton


const upon_death_tip = 6


func start_of_round_ability() ->void:
	pass


func end_of_round_ability() ->void:
	pass


func after_eating_ability() ->void:
	if dead:
		return
	current_poison = current_poison * 2


func start_of_day_ability() ->void:
	pass


func end_of_day_ability() ->void:
	pass


func upon_death_ability() -> void:
	tips(upon_death_tip)
