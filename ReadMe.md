# Fimmfu

A dark strategy game built in **Godot 4** using **GDScript**, where you run a restaurant that serves decayed customers, by poisoning their meals.

## About the Game

In *Fimmfu*, you manage ingredients, prepare dishes, and strategically poison monster patrons (Ghosts, Skeletons, and Vampires) to survive each night. Balance your economy, choose your poisons wisely, and keep your alibi up 

**Key mechanics:**
- Turn-based serving loop with resource management
- Ingredient purchasing system with dynamic pricing and bulk incentives
- Multiple poison types with creature-specific effectiveness
- Escalating difficulty across increasingly dangerous nights
- Shop phase between rounds for restocking and strategy

## Technical Highlights

- **Engine:** Godot 4.x
- **Language:** GDScript (100%)
- **Architecture:** Scene-based game loop (Main -> TableGameLoop -> SceneTransition) with modular UI systems
- **Systems implemented:**
  - Custom tween-based animation pipeline (death animations, intro cutscene, damage flash, CheckBar)
  - Dynamic shop/economy system (IngredientsManager, IngredientForSale)
  - Round flow, controled by mainly by table.gd -> customer.gd


## Play It

https://gustapa8.itch.io/fimmfu

## Author

### Programming and game design
**Henrique Baumegger**
BSc Student — ETH Zürich

### Art
**Lisanne van Lunteren**
BSc Student — ETH Zürich
