extends ColorRect
class_name SceneTransition


const FADE_IN_TIME := 3
const FADE_OUT_TIME := 5
const HOLD_TIME := 1


func go_to_black() -> void:
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, FADE_IN_TIME)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tw.finished


func wait_and_go_to_transparent() -> void:
	var tw := create_tween()
	tw.tween_interval(HOLD_TIME)
	tw.tween_property(self, "modulate:a", 0.0, FADE_OUT_TIME)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tw.finished
