class_name AbilityPanel
extends PanelContainer

var ability: Ability:
	set(value):
		ability = value
		_update()
var is_selected := false
var disabled := false

signal hovered
signal unhovered
signal selected
signal deselected


func _update():
	%Name.text = ability.name
	%Description.text = ability.effect.description
	%TextureRect.texture = ability.icon


func _on_mouse_entered() -> void:
	if not is_selected and not disabled:
		modulate = Color.DARK_SLATE_GRAY
		hovered.emit()
		$OnHover.play()


func _on_mouse_exited() -> void:
	if not is_selected and not disabled:
		modulate = Color.WHITE
		unhovered.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("deselect") and is_selected:
		deselect()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and not disabled:
		select()
		$OnSelect.play()


func select():
	if not is_selected and not disabled:
		is_selected = true
		_selected_appearance()
		selected.emit()


func deselect():
	if not disabled:
		_default_appearance()
		is_selected = false
		deselected.emit()


func enable():
	disabled = false
	is_selected = false
	_default_appearance()


func disable():
	disabled = true
	is_selected = false
	_disabled_appearance()


func _default_appearance():
	scale = Vector2(1, 1)
	z_index = 0
	modulate = Color.WHITE


func _selected_appearance():
	modulate = Color.DARK_SLATE_GRAY
	z_index = 1
	scale = Vector2(1.25, 1.25)


func _disabled_appearance():
	scale = Vector2(1, 1)
	z_index = 0
	modulate = Color.RED
