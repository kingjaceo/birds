class_name PartyDisplayPanel
extends PanelContainer

@export var max_size: int = 3
var current_size: int:
	get:
		return _characters.size()
var character_panel_scene = load("res://ui/small_character_panel.tscn")
var characters_to_panels: Dictionary[CharacterData, SmallCharacterPanel]
var current_party: Array[CharacterData]:
	get: return _characters
var current_character: CharacterData:
	get:
		return _current_character
var has_room: bool: 
	get: return current_size < max_size
var _characters: Array[CharacterData]
var _current_character: CharacterData

signal character_selected(character: CharacterData)
signal character_removed(character: CharacterData)


func _ready():
	_update_label()


func add_character(character: CharacterData):
	if _current_character:
		_replace_character(_current_character, character)
		return
	elif current_size == max_size:
		var last_character = _characters[-1]
		_remove_character(last_character)
	var new_panel = character_panel_scene.instantiate()
	new_panel.character = character
	%VBoxContainer.add_child(new_panel)
	characters_to_panels[character] = new_panel
	_characters.append(character)
	new_panel.selected.connect(_on_character_selected.bind(character))
	new_panel.deselected.connect(_on_character_deselected.bind(character))
	_update_label()


func remove_current_character():
	characters_to_panels[_current_character].free()
	characters_to_panels.erase(_current_character)
	_characters.erase(current_character)
	_current_character = null
	_update_label()


func _remove_character(character: CharacterData):
	characters_to_panels[character].free()
	characters_to_panels.erase(character)
	_characters.erase(character)
	character_removed.emit(character)
	if character == _current_character:
		_current_character = null
	_update_label()


func _replace_character(old: CharacterData, new: CharacterData):
	var panel = characters_to_panels[old]
	panel.character = new
	characters_to_panels.erase(old)
	characters_to_panels[new] = panel
	var index = _characters.find(old)
	_characters.pop_at(index)
	_characters.insert(index, new)
	_current_character = null
	character_removed.emit(old)
	panel.selected.disconnect(_on_character_selected)
	panel.deselected.disconnect(_on_character_deselected)
	panel.selected.connect(_on_character_selected.bind(new))
	panel.deselected.connect(_on_character_deselected.bind(new))
	panel.deselect()


func _on_character_selected(character: CharacterData):
	for panel: SmallCharacterPanel in characters_to_panels.values():
		if panel.character != character:
			panel.deselect()
	_current_character = character
	character_selected.emit(character)


func _on_character_deselected(character: CharacterData):
	_current_character = null


func _update_label():
	%Label.text = "Party (" + str(current_size) + " / " + str(max_size) + ")"
