class_name Roost
extends Node2D

@export var characters: Array[CharacterData]
@export var current_mission: PackedScene = load("res://level/level.tscn")
var _current_character: CharacterData
var current_party: Array[CharacterData]:
	get: return %PartyDisplay.current_party

signal mission_and_party_selected(mission: PackedScene, party: Array[CharacterData])
# TODO: should the different "character" lists be tracked here:
#  _available_characters, _current_party, etc
#  pass arrays down to the children components?

func _ready():
	%Remove.disabled = true
	%Enlist.disabled = true
	%Go.disabled = true
	_setup_icon_buttons()


func _setup_icon_buttons():
	%AvailableCharacters.characters = characters


func _update_character_display(character: CharacterData):
	_current_character = character
	%Enlist.disabled = false
	%CharacterDisplayContainer.character = character


func _on_enlist_pressed() -> void:
	%CharacterDisplayContainer.clear()
	%PartyDisplay.add_character(_current_character)
	%AvailableCharacters.disable_character(_current_character)
	%Remove.disabled = false
	%Go.disabled = false


func _on_remove_pressed() -> void:
	%Remove.disabled = %PartyDisplay.current_size == 0
	%Go.disabled = %PartyDisplay.current_size == 0
	%AvailableCharacters.make_character_available(%PartyDisplay.current_character)
	%PartyDisplay.remove_current_character()


func _on_character_removed_from_party(character: CharacterData) -> void:
	%AvailableCharacters.make_character_available(character)


func _on_go_pressed() -> void:
	mission_and_party_selected.emit(current_mission, current_party)
