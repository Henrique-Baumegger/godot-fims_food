# godot-fims-food

## My conventions
### Function order
- possible overrider
- public : no "_" at the start
- private : "_" at the start

## Groups




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

- Make base scene, and from that, recreate all 4 classes


### Food
- Modify ingredients_present logic, and how food stores its ingredients.
		- Potentially modify how customers eat the food
