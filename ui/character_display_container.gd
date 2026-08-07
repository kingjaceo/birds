extends Control

var ability_panel_scene = load("res://abilities/ability_panel.tscn")
var character: CharacterData:
	set(value):
		character = value
		_update()

signal character_enlisted(character: CharacterData)


func _ready():
	for child in %HBoxContainer.get_children():
		child.free()
	%CharacterHolder.get_child(0).free()


func _update():
	clear()
	for i in range(character.abilities.size()):
		var new_panel = ability_panel_scene.instantiate()
		new_panel.ability = character.abilities[i]
		new_panel.disabled = true
		%HBoxContainer.add_child(new_panel)
	%CharacterHolder.add_child(character.sprite.instantiate())
	%CharacterHolder.get_child(0).scale = Vector2(0.5, 0.5)


func clear():
	for child in %HBoxContainer.get_children():
		child.free()
	for child in %CharacterHolder.get_children():
		child.free()


func _on_character_selected(_character: CharacterData) -> void:
	character = _character
