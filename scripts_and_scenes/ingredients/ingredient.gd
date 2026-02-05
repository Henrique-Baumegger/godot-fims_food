extends Node2D
class_name Ingredient

@export var ingredient_name : String = "no name yet"
@export var sprite : Texture2D = null
@export var initial_quantity : int 

var dragging : bool = false
var mouse_is_on_static_ingredient : bool = false

var static_quantity : int 
var dragged_quantity = 0

@onready var static_ingredient: Node2D = $StaticIngredient
@onready var dragged_ingredient: Node2D = $DraggedIngredient
@onready var static_label: Label = $StaticIngredient/StaticLabel
@onready var dragged_label: Label = $DraggedIngredient/DraggedLabel
@onready var static_sprite: Sprite2D = $StaticIngredient/StaticSprite
@onready var dragged_sprite: Sprite2D = $DraggedIngredient/DraggedSprite


func _ready() -> void:
	dragged_ingredient.visible = false
	static_quantity = initial_quantity
	update_labels()
	set_up_sprites()

func _process(_delta):
	handle_potential_click()
	handle_potential_dragging_movement()

func handle_potential_click() -> void:
	if not Input.is_action_just_pressed("left_click"):
		return
	
	var potential_food : Food = get_potential_food()
	if potential_food != null and dragged_quantity > 0:
		handle_ingredient_addition(potential_food)
		cancel_drag()
	elif dragged_quantity == 0 and mouse_is_on_static_ingredient and static_quantity >0:
		start_dragging()
		dragged_quantity = 1
		static_quantity -= 1
		update_labels()
	elif dragged_quantity > 0 and mouse_is_on_static_ingredient and static_quantity >0:
		dragged_quantity += 1
		static_quantity -= 1
		update_labels()
	elif not mouse_is_on_static_ingredient and dragging:
		cancel_drag()


func get_potential_food() -> Food: # Null if none
	var result : Food = null
	
	var space_state = get_world_2d().direct_space_state
	var pq := PhysicsPointQueryParameters2D.new()
	pq.position = get_global_mouse_position()
	pq.collide_with_areas = true
	var results_as_array_of_dictionaries = space_state.intersect_point(pq)
	for current_dict in results_as_array_of_dictionaries:
		if current_dict["collider"].is_in_group("food_area"):
			result = current_dict["collider"]
			break
	return result


func handle_ingredient_addition(_current_food: Food) -> void:
	var added = _current_food.try_to_add(ingredient_name, dragged_quantity)
	dragged_quantity = dragged_quantity- added
	return


func cancel_drag() -> void:
	static_quantity = dragged_quantity + static_quantity
	dragged_quantity = 0
	update_labels()
	
	dragging = false
	dragged_ingredient.visible = false
	dragged_ingredient.position = Vector2(0,0) # Relative to the parent


func update_labels() -> void:
	static_label.text = str(static_quantity)
	dragged_label.text = str(dragged_quantity)


func start_dragging() -> void:
	dragging = true
	dragged_ingredient.visible = true
	handle_potential_dragging_movement()


func handle_potential_dragging_movement() -> void:
	if !dragging:
		return
	dragged_ingredient.global_position = get_global_mouse_position()


func _on_static_ingredient_area_mouse_entered() -> void:
	mouse_is_on_static_ingredient = true


func _on_static_ingredient_area_mouse_exited() -> void:
	mouse_is_on_static_ingredient = false


func set_up_sprites() -> void:
	static_sprite.texture = sprite
	dragged_sprite.texture = sprite
