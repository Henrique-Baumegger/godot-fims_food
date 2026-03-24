extends ColorRect
class_name DamageEffect

const damage_animation_name : String = "damage_animation"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_damage_animation()-> void:
	animation_player.play(damage_animation_name)
