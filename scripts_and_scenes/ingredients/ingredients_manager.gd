extends Node2D
class_name IngredientsManager

@export var initial_holly_water_quantity = 99
@export var initial_warm_ingredient_quantity = 99
@export var initial_drinks_quantity = 99


@onready var holy_water: Ingredient = $HolyWater
@onready var onion: Ingredient = $Onion
@onready var salt: Ingredient = $Salt
@onready var silver: Ingredient = $Silver
@onready var left_dessert: Ingredient = $LeftDessert
@onready var stay_dessert: Ingredient = $StayDessert
@onready var right_dessert: Ingredient = $RightDessert

# Initialization order goes as following:
# Parent _enter_tree() ← top-down
# Child _enter_tree() ← top-down
# Child _ready() ← bottom-up
# Parent _ready() ← bottom-up

func _enter_tree():
	#ready has not ran yet
	$HolyWater.set_initial_quantity(initial_holly_water_quantity)
	$Onion.set_initial_quantity(initial_warm_ingredient_quantity)
	$Salt.set_initial_quantity(initial_warm_ingredient_quantity)
	$Silver.set_initial_quantity(initial_warm_ingredient_quantity)
	$LeftDessert.set_initial_quantity(initial_drinks_quantity)
	$StayDessert.set_initial_quantity(initial_drinks_quantity)
	$RightDessert.set_initial_quantity(initial_drinks_quantity)


func toggle_warm_ingredients_selectability(on : bool) -> void:
	holy_water.toggle_selectability(on)
	onion.toggle_selectability(on)
	salt.toggle_selectability(on)
	silver.toggle_selectability(on)


func toggle_all_ingredients_selectability(on : bool) -> void:
	holy_water.toggle_selectability(on)
	onion.toggle_selectability(on)
	salt.toggle_selectability(on)
	silver.toggle_selectability(on)
	left_dessert.toggle_selectability(on)
	stay_dessert.toggle_selectability(on)
	right_dessert.toggle_selectability(on)
