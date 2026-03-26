extends Area2D
class_name IngredientForSale

@export var collision_2d : CollisionShape2D = null
@export var sprite_node : Node = null

@export var is_health_potion : bool = false
@export var is_holy_water : bool = false
@export var poison_type : Customer.Creatures = Customer.Creatures.NONE
@export var drink_type : Food.Drinks = Food.Drinks.NONE

@export var price : int = 5
@export var batch_quantity : int = 5
@export var batch_increment : int = 1
@export var is_single_purchase : bool = false

var has_been_purchased : bool = false

var mouse_in_area : bool = false

var money_manager : MoneyManager = null
var life_manager : LifeManager = null
var ingredients_manager : IngredientsManager = null

@onready var item_quantity: Label = $ItemQuantity


func _ready() -> void:
	_check_exports()
	money_manager = get_tree().get_first_node_in_group("money_manager")
	life_manager = get_tree().get_first_node_in_group("life_manager")
	ingredients_manager = get_tree().get_first_node_in_group("ingredients_manager")


func _process(_delta: float) -> void:
	_handle_potential_buy()
	_update_visuals()


func _handle_potential_buy() -> void:
	if not(mouse_in_area and Input.is_action_just_pressed("left_click"))\
	or (is_single_purchase and has_been_purchased)\
	or (money_manager.get_money() < price):
		return
	
	if is_health_potion:
		life_manager.fill_life()
	else:
		ingredients_manager.add_product(self, batch_quantity)
	
	batch_quantity = batch_quantity + batch_increment
	money_manager.add_money(-price)
	has_been_purchased = true


func _update_visuals() -> void:
	item_quantity.text = "Batch of: " + str(batch_quantity)
	
	if (is_single_purchase and has_been_purchased)\
	 or (money_manager.get_money() < price):
		modulate = Color(0.8, 0.8, 0.8, 0.6)


func _check_exports() -> void:
	var count := 0
	if is_health_potion:
		count += 1
	if is_holy_water:
		count += 1
	if poison_type != Customer.Creatures.NONE:
		count += 1
	if drink_type != Food.Drinks.NONE:
		count += 1
	assert(count == 1, "%s: exactly one export must be set, but %d were." % [name, count])
	
	assert(collision_2d != null)
	assert(sprite_node != null)


func _on_mouse_entered() -> void:
	mouse_in_area = true


func _on_mouse_exited() -> void:
	mouse_in_area = false
