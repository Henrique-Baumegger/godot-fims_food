extends Sprite2D


@export var candle_sprites : Array [Texture2D]


func _ready() -> void:
	texture = candle_sprites.pick_random()
