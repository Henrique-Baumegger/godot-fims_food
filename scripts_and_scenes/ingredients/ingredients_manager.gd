extends Node2D
class_name IngredientsManager

@export var initial_holly_water_quantity: int = 4
@export var initial_garlic_quantity: int = 12
@export var initial_salt_quantity: int = 4
@export var initial_silver_quantity: int = 8
@export var initial_drinks_quantity: int = 1

var warm_ingredients : Dictionary[Customer.Creatures , Ingredient]
var drinks : Dictionary[Food.Drinks, Ingredient]

@onready var holy_water: Ingredient = $HolyWater
@onready var garlic: Ingredient = $Garlic
@onready var salt: Ingredient = $Salt
@onready var silver: Ingredient = $Silver
@onready var left_dessert: Ingredient = $LeftDessert
@onready var stay_dessert: Ingredient = $StayDessert
@onready var right_dessert: Ingredient = $RightDessert


func add_product(product : IngredientForSale, quantity : int) -> void:
	if product.is_holy_water:
		holy_water.static_quantity += quantity
	if product.poison_type != Customer.Creatures.NONE:
		warm_ingredients[product.poison_type].static_quantity += quantity
	if product.drink_type != Food.Drinks.NONE:
		drinks[product.drink_type].static_quantity += quantity


func toggle_warm_ingredients_selectability(on : bool) -> void:
	holy_water.toggle_selectability(on)
	garlic.toggle_selectability(on)
	salt.toggle_selectability(on)
	silver.toggle_selectability(on)


func toggle_all_ingredients_selectability(on : bool) -> void:
	holy_water.toggle_selectability(on)
	garlic.toggle_selectability(on)
	salt.toggle_selectability(on)
	silver.toggle_selectability(on)
	left_dessert.toggle_selectability(on)
	stay_dessert.toggle_selectability(on)
	right_dessert.toggle_selectability(on)


# Initialization order goes as following:
# Parent _enter_tree() ← top-down
# Child _enter_tree() ← top-down
# Child _ready() ← bottom-up
# Parent _ready() ← bottom-up
func _enter_tree():
	#ready has not ran yet
	$HolyWater.set_initial_quantity(initial_holly_water_quantity)
	$Garlic.set_initial_quantity(initial_garlic_quantity)
	$Salt.set_initial_quantity(initial_salt_quantity)
	$Silver.set_initial_quantity(initial_silver_quantity)
	$LeftDessert.set_initial_quantity(initial_drinks_quantity)
	$StayDessert.set_initial_quantity(initial_drinks_quantity)
	$RightDessert.set_initial_quantity(initial_drinks_quantity)


func _ready() -> void:
	warm_ingredients= {
		Customer.Creatures.VAMPIRE : garlic ,
		Customer.Creatures.SKELETON : salt ,
		Customer.Creatures.GHOST : silver
	}
	drinks = {
		Food.Drinks.GO_LEFT : left_dessert,
		Food.Drinks.STAY : stay_dessert,
		Food.Drinks.GO_RIGHT : right_dessert,
	}
