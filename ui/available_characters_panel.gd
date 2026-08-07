extends VBoxContainer

var icon_button_scene = load("res://ui/icon_button.tscn")
var characters: Array[CharacterData]:
	set(value):
		characters = value
		_update()
var characters_to_buttons: Dictionary[CharacterData, IconButton]

signal character_selected(character: CharacterData)


func disable_character(character: CharacterData):
	characters_to_buttons[character].disable()


func _update():
	for character in characters:
		var icon_button = icon_button_scene.instantiate()
		icon_button.icon = character.icon
		icon_button.selected.connect(_deselect_other_buttons.bind(icon_button))
		icon_button.selected.connect(character_selected.emit.bind(character))
		%HBoxContainer.add_child(icon_button)
		characters_to_buttons[character] = icon_button


func _deselect_other_buttons(icon_button: IconButton):
	for other_button: IconButton in %HBoxContainer.get_children():
		if icon_button != other_button:
			other_button.deselect()


func make_character_available(character: CharacterData):
	characters_to_buttons[character].enable()
