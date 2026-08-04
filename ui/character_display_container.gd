extends Control

var character: Character:
	set(value):
		character = value
		_update()


func _update():
	for i in range(character.abilities.size()):
		var panel: AbilityPanel = $HBoxContainer.get_child(i)
		panel.ability = character.abilities[i]
		panel.disabled = true
