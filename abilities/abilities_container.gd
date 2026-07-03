class_name AbilitiesContainer
extends HBoxContainer

var ability_panel_scene = load("res://abilities/ability_panel.tscn")
var _selected_panel: AbilityPanel
var _selected_character: Character


func _ready():
	%AbilityManager.ability_finished.connect(_deselect)
	for character: Character in %Characters.get_children():
		setup(character)


func setup(character: Character):
	for ability in character.abilities:
		var ability_panel = ability_panel_scene.instantiate()
		ability_panel.ability = ability
		ability_panel.hovered.connect(character.highlight)
		ability_panel.unhovered.connect(character.unhighlight)
		ability_panel.selected.connect(_on_panel_selected.bind(ability_panel, character))
		add_child(ability_panel)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("deselect"):
		_deselect()


func _on_panel_selected(panel: AbilityPanel, character: Character):
	if not %AbilityManager.is_executing():
		_deselect()
		_selected_panel = panel
		character.select()
		_selected_character = character
		%AbilityManager.select_ability(_selected_character, panel.ability)


func _deselect():
	if _selected_panel:
		_selected_panel.deselect()
		_selected_character.deselect()
	_selected_panel = null
	_selected_character = null
