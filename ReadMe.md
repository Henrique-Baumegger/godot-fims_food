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
	- eat_and_free_food(), 
	- after_eating_ability(), 
	- dying_check(), 
	- killing_you_probability_check()
	- end_of_round_ability()
	- end_of_day_ability()


### Table
- Make 1 instantiatible scene for each table size, up to 5. This we, we can place markers manually
- On the base table scene, we export a bunch of markers, so that we can use that node on a scene,
and add markers as children. At _ready, check if all list sizes are equal, and check if Label List marker was added
	- Label List marker
	- Array of food markers
	- Array of list customers markers
	- Array of normal customer markers
	- Array of Candles position markers (-1 size)

- Export textures for candles and pick randomly

- Table should manage initialization and call customer lifecycle methods.

- Table itself should have lifecycle methods that will be called by main