extends Customer
class_name Skeleton


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
