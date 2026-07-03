class_name AbilityPanel
extends PanelContainer

var ability: Ability:
	set(value):
		ability = value
		_update()
var is_selected := false

signal selected
signal deselected
signal hovered
signal unhovered


func _update():
	%Name.text = ability.name
	%Description.text = "NA"


func _on_mouse_entered() -> void:
	if not is_selected:
		modulate = Color.DARK_SLATE_GRAY
		hovered.emit()


func _on_mouse_exited() -> void:
	if not is_selected:
		modulate = Color.WHITE
		unhovered.emit()


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("deselect"):
		#_deselect()
		#get_viewport().set_input_as_handled()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		select()


func select():
	modulate = Color.DARK_SLATE_GRAY
	is_selected = true
	selected.emit()


func deselect():
	modulate = Color.WHITE
	is_selected = false
	deselected.emit()
