extends Node2D
class_name ShopGameLoop

@onready var stay_drink_for_sale: Node2D = $DrinkOfTheDay/StayDrinkForSale
@onready var left_drink_for_sale: Node2D = $DrinkOfTheDay/LeftDrinkForSale
@onready var right_drink_for_sale: Node2D = $DrinkOfTheDay/RightDrinkForSale

@onready var holy_water_for_sale: Node2D = $LastInStock/HolyWaterForSale
@onready var sewing_kit_for_sale: Node2D = $LastInStock/SewingKitForSale

@onready var garlic_for_sale: Node2D = $AbundanceOfTheVast/GarlicForSale
@onready var salt_for_sale: Node2D = $AbundanceOfTheVast/SaltForSale
@onready var silver_for_sale: Node2D = $AbundanceOfTheVast/SilverForSale


func _ready() -> void:
	_keep_one_drink()


func _keep_one_drink()-> void:
	var all_drinks : Array[Node2D] = [left_drink_for_sale, stay_drink_for_sale, right_drink_for_sale]
	all_drinks.shuffle()
	all_drinks[0].queue_free()
	all_drinks[1].queue_free()
