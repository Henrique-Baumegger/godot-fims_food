extends Area2D
class_name ToolTipArea

const OFFSET: Vector2 = Vector2.ONE * 60.0
var opacity_tween: Tween = null

@export_multiline var displayed_text : String = ""

@onready var tip_panel: PanelContainer = $TipPanel
@onready var rich_text_label: RichTextLabel = $TipPanel/MarginContainer/RichTextLabel


func _process(_delta: float) -> void:
	rich_text_label.text = displayed_text
	if not tip_panel.visible:
		return
	var vp := get_viewport_rect().size
	var s := tip_panel.size
	var p := get_global_mouse_position() + OFFSET
	p.x = clamp(p.x, 0.0, vp.x - s.x)
	p.y = clamp(p.y, 0.0, vp.y - s.y)
	tip_panel.global_position = p



func toggle(on: bool):
	if on:
		tip_panel.visible = true
		tip_panel.modulate.a = 0.0
		tween_opacity(1.0)
	else:
		tip_panel.modulate.a = 1.0
		await tween_opacity(0.0).finished
		tip_panel.visible = false
		tip_panel.position = Vector2.ZERO # relative to parent


func tween_opacity(to: float):
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(tip_panel, "modulate:a", to, 0.1)
	return opacity_tween


func _on_mouse_entered() -> void:
	toggle(true)


func _on_mouse_exited() -> void:
	toggle(false)
