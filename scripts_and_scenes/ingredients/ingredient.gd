## Lifecycle methods to be called by parent:
## toggle_warm_ingredients_selectability
extends Node2D
class_name Ingredient


@export var poison_type : Customer.Creatures = Customer.Creatures.NONE
@export var drink_type : Food.Drinks = Food.Drinks.NONE

@export var initial_quantity : int = 0
@export var current_texture : Texture2D = null

var dragging : bool = false
var mouse_is_on_static_ingredient : bool = false
var blocked : bool = false

var static_quantity : int 
var dragged_quantity : int = 0

@onready var static_ingredient: Node2D = $StaticIngredient
@onready var dragged_ingredient: Node2D = $DraggedIngredient
@onready var static_label: Label = $StaticIngredient/StaticLabel
@onready var dragged_label: Label = $DraggedIngredient/DraggedLabel
@onready var static_sprite: Sprite2D = $StaticIngredient/StaticSprite
@onready var dragged_sprite: Sprite2D = $DraggedIngredient/DraggedSprite


func toggle_warm_ingredients_selectability(on : bool)-> void:
	if !on and drink_type == Food.Drinks.NONE:
		blocked = true
		modulate = Color(0.8, 0.8, 0.8, 0.6)
	elif on:
		blocked = false
		modulate = Color.WHITE


func _ready() -> void:
	dragged_ingredient.visible = false
	static_quantity = initial_quantity
	static_sprite.texture = current_texture
	dragged_sprite.texture = current_texture
	_update_labels()


func _process(_delta):
	if blocked:
		if dragging:
			_cancel_drag()
		return
	
	_handle_potential_click()
	_handle_potential_dragging_movement()


func _handle_potential_click() -> void:
	if not Input.is_action_just_pressed("left_click"):
		return
	
	var potential_food : Food = _get_potential_food()
	if potential_food != null and dragged_quantity > 0:
		_handle_ingredient_addition(potential_food)
		_cancel_drag()
	elif dragged_quantity == 0 and mouse_is_on_static_ingredient and static_quantity >0:
		_start_dragging()
		dragged_quantity = 1
		static_quantity -= 1
		_update_labels()
	elif dragged_quantity > 0 and mouse_is_on_static_ingredient and static_quantity >0:
		dragged_quantity += 1
		static_quantity -= 1
		_update_labels()
	elif not mouse_is_on_static_ingredient and dragging:
		_cancel_drag()


func _get_potential_food() -> Food: # Null if none
	var result : Food = null
	
	var space_state = get_world_2d().direct_space_state
	var pq := PhysicsPointQueryParameters2D.new()
	pq.position = get_global_mouse_position()
	pq.collide_with_areas = true
	var results_as_array_of_dictionaries = space_state.intersect_point(pq)
	for current_dict in results_as_array_of_dictionaries:
		var node_found = current_dict["collider"]
		if node_found is Food:
			result = node_found
			break
	return result


func _handle_ingredient_addition(found_food: Food) -> void:
	var added = found_food.try_to_add(self, dragged_quantity)
	dragged_quantity = dragged_quantity - added
	return


func _cancel_drag() -> void:
	static_quantity = dragged_quantity + static_quantity
	dragged_quantity = 0
	_update_labels()
	
	dragging = false
	dragged_ingredient.visible = false
	dragged_ingredient.position = Vector2(0,0) # Relative to the parent


func _update_labels() -> void:
	static_label.text = str(static_quantity)
	dragged_label.text = str(dragged_quantity)


func _start_dragging() -> void:
	dragging = true
	dragged_ingredient.visible = true


func _handle_potential_dragging_movement() -> void:
	if !dragging:
		return
	dragged_ingredient.global_position = get_global_mouse_position()


func _on_static_ingredient_area_mouse_entered() -> void:
	mouse_is_on_static_ingredient = true


func _on_static_ingredient_area_mouse_exited() -> void:
	mouse_is_on_static_ingredient = false
