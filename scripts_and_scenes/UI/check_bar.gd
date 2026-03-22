extends Control


const fade_in_out_time : float = 0.2

var bar_width: float 

@onready var background: ColorRect = $Background
@onready var purple_bar: ColorRect = $PurpleBar
@onready var red_zone: ColorRect   = $RedZone
@onready var needle: ColorRect     = $Needle


func run_check(poison: float, max_poison: float, percentage_of_poison_to_kill: float) -> bool:
	var poison_ratio: float = poison / max_poison
	var damage_chance: float  = poison_ratio * percentage_of_poison_to_kill
	purple_bar.size.x = bar_width * poison_ratio
	red_zone.size.x   = bar_width * damage_chance
	
	var hit: bool = randf() < damage_chance
	var target_x: float
	
	if hit:
		var safe_max: float = maxf(red_zone.size.x - needle.size.x, 0.0)
		var point_on_red : float = randf_range(0.0, safe_max)
		target_x = point_on_red
	else:
		var safe_start: float = red_zone.size.x
		var safe_end: float   = bar_width - needle.size.x
		var point_outside_red : float = randf_range(safe_start, safe_end)
		target_x = point_outside_red
	
	await _appear_and_disappear(true)
	await _animate_oscillation(target_x)
	await _appear_and_disappear(false)
	return hit


func _ready() -> void:
	visible = false
	bar_width = background.size.x
	run_check(6, 10, 1.0/2.0)


func _appear_and_disappear(appear:bool) -> void:
	if appear:
		modulate.a = 0.0
		visible = true
		var tween := create_tween()
		tween.tween_property(self, "modulate:a", 1.0, fade_in_out_time)
		await tween.finished
	else:
		var tween := create_tween()
		tween.tween_property(self, "modulate:a", 0.0, fade_in_out_time)
		await tween.finished
		visible = false


func _animate_oscillation(target_x: float) -> void:
	
	needle.position.x = needle.size.x
	var start_x : float = needle.position.x
	
	# list of waypoints the needle will pass through
	var waypoints: Array[float] = _build_waypoints(start_x, target_x)
	
	var tween: Tween = create_tween()
	# Tweens execute their segments SEQUENTIALLY by default.
	# Each tween_property() call adds one segment to the queue.
	
	var num_waypoints: int = waypoints.size()
	for i in range(num_waypoints):
		var current_waypoint: float = waypoints[i]
		# Duration increases with each swing — the needle "slows down" as
		# it runs out of energy. Early swings are fast, final landing is slow.
		var duration: float = 0.25 + i * 0.12
		var is_final: bool = (i == num_waypoints - 1)
		# tween_property returns a PropertyTweener, which has its own
		# set_ease / set_trans methods. This lets each segment have independent easing. 
		if is_final:
			tween.tween_property(needle, "position:x", current_waypoint, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		else:
			tween.tween_property(needle, "position:x", current_waypoint, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	await tween.finished


func _build_waypoints(start_x: float, target_x: float) -> Array[float]:
	# Build oscillation waypoints converging on target_x.
	var total_distance: float = absf(target_x - start_x)
	# Overshoot amounts: each one is a fraction of the previous
	var o1: float = total_distance * 0.55  
	var o2: float = o1 * 0.40             
	var o3: float = o2 * 0.30             
	
	var direction: float = sign(start_x - target_x)  # +1 or -1
	var min_x: float = 0.0
	var max_x: float = bar_width - needle.size.x

	return [
		# Swing past target in the approach direction
		clampf(target_x + direction * o1, min_x, max_x),
		# Rebound back, less distance
		clampf(target_x - direction * o2, min_x, max_x),
		# Tiny wobble forward
		clampf(target_x + direction * o3, min_x, max_x),
		# Final landing — exact target
		clampf(target_x, min_x, max_x),
	]
