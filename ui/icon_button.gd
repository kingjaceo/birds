class_name IconButton
extends PanelContainer

var icon: Texture2D:
	set(new_icon):
		icon = new_icon
		$TextureRect.texture = icon
var is_selected: bool
var is_disabled: bool

signal selected


func deselect():
	if not is_disabled:
		modulate = Color.WHITE
		is_selected = false


func disable():
	modulate = Color(0.0, 0.0, 0.0, 1.0)
	is_disabled = true
	is_selected = false


func enable():
	modulate = Color.WHITE
	is_disabled = false


func _on_mouse_entered() -> void:
	if not is_disabled:
		modulate = Color.DARK_SLATE_GRAY


func _on_mouse_exited() -> void:
	if not is_selected and not is_disabled:
		modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and not is_disabled:
		modulate = Color.DARK_SLATE_GRAY
		selected.emit()
		is_selected = true
