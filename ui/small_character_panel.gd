class_name SmallCharacterPanel
extends HBoxContainer

var ability_panel_scene = load("res://abilities/ability_panel.tscn")
var character: CharacterData:
	set(value):
		character = value
		_update()
var is_selected: bool

signal selected
signal deselected


func select():
	selected.emit()
	is_selected = true
	modulate = Color.DARK_SLATE_GRAY


func deselect():
	deselected.emit()
	is_selected = false
	modulate = Color.WHITE


func _update():
	for child: AbilityPanel in %Abilities.get_children():
		child.free()
	for ability in character.abilities:
		var new_panel = ability_panel_scene.instantiate()
		new_panel.ability = ability
		new_panel.disabled = true
		%Abilities.add_child(new_panel)
	%TextureRect.texture = character.icon


func _on_mouse_entered() -> void:
	modulate = Color.DARK_SLATE_GRAY


func _on_mouse_exited() -> void:
	if not is_selected:
		modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and not is_selected:
		select()
	elif event.is_action_pressed("select"):
		deselect()
