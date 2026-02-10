# godot-fims-food

## Groups

### round_dependers
- Can define following functions that will be called by main loop 
(not obligatory)
	- func start_day() -> void:
	- func start_round() -> void:
	- func clients_go_to_table() -> void:
	- func assign_food() -> void:
	- func finish_round() -> void:
	- func finish_day() -> void:


## TODO
### Customer refactor
- Owner of all the clients (likely the table), will have to call each stage of the clients.
		- start_of_day_ability(),
		- start_of_round_ability(),
		- eat_food(), 
		- end_of_round_ability(), 
		- dying_check(), 
		- killing_you_probability_check()
		- end_of_day_ability()
