class_name AbilitiesContainer
extends HBoxContainer

@export var controller: PlayerController # could be set by TurnManager
var ability_panel_scene = load("res://abilities/ability_panel.tscn")
var selected_ability: Ability
var hovered_ability: Ability
var _selected_panel: AbilityPanel
#var _selected_character: Character
var current_abilities: Array#[Ability]
var _panels_to_abilities: Dictionary[AbilityPanel, Ability]
var disabled := false
var abilities_executing := 0

signal turn_finished
signal ability_discarded(ability: Ability)
signal undo_pressed
signal ability_selected(ability: Ability)
signal ability_deselected # only gets called on a RIGHT CLICK


func _ready():
	%EndTurn.pressed.connect(_force_discard)
	%Undo.pressed.connect(undo_pressed.emit)
	# if the player plays max abiltiies, disable all panels
	_connect_controller()
	for ability in controller.playable_abilities:
		var ability_panel: AbilityPanel = ability_panel_scene.instantiate()
		ability_panel.ability = ability
		ability_panel.hovered.connect(_on_panel_hovered.bind(ability))
		ability_panel.unhovered.connect(_on_panel_unhovered.bind(ability))
		ability_panel.selected.connect(_on_panel_selected.bind(ability_panel))
		ability_panel.deselected.connect(_on_panel_deselected.bind(ability_panel))
		#ability_selected.connect(_on_ability_selected.bind(ability_panel))
		#ability.executed.connect(ability_panel.disable.unbind(1))
		add_child(ability_panel)
		_panels_to_abilities[ability_panel] = ability


func _connect_controller():
	controller.disabled.connect(_disable)
	#controller.enabled.connect(_enable)
	controller.max_abilities_played.connect(_disable_all_panels)
	controller.history_changed.connect(_update_panels)
	controller.ability_started.connect(_on_ability_start)
	controller.ability_finished.connect(_on_ability_finish)
	controller.abilities_played_changed.connect(_update_undo.unbind(1))


func _enable():
	disabled = false
	%EndTurn.visible = true
	%EndTurn.disabled = false
	%Undo.visible = true
	%Undo.disabled = true
	%Discard.visible = false
	_enable_panels(controller.playable_abilities)


func _enable_panels(abilities: Array[Ability]):
	for panel: AbilityPanel in _panels_to_abilities:
		if _panels_to_abilities[panel] in abilities:
			panel.enable()
		else:
			panel.disable()


func _disable():
	disabled = true
	%Discard.visible = false
	selected_ability = null
	_disable_all_panels()


func _disable_all_panels():
	for panel in _panels_to_abilities:
		panel.disable()


func _force_discard():
	turn_finished.emit()
	%Discard.visible = true
	%Discard.disabled = false
	%Undo.visible = false
	%EndTurn.visible = false
	selected_ability = null
	_enable_panels(controller.all_abilities)
	while not selected_ability:
		%Discard.disabled = false
		await %Discard.pressed
	ability_discarded.emit(selected_ability)


func _on_ability_start():
	abilities_executing += 1
	%Undo.disabled = true


func _on_ability_finish():
	abilities_executing -= 1
	if abilities_executing == 0:
		_update_undo()


func _update_undo() -> void:
	if controller.abilities_played > 0 and abilities_executing == 0:
		%Undo.disabled = false
	else:
		%Undo.disabled = true


func _update_panels():
	if not disabled:
		for panel in _panels_to_abilities:
			if _panels_to_abilities[panel] in controller.playable_abilities:
				panel.enable()
			else:
				panel.disable()


func _on_panel_hovered(ability: Ability):
	ability.character.highlight()
	hovered_ability = ability


func _on_panel_unhovered(ability: Ability):
	ability.character.unhighlight()
	hovered_ability = null


func _on_panel_selected(ability_panel: AbilityPanel):
	for panel: AbilityPanel in get_children():
		if panel != ability_panel:
			panel.deselect()
	_selected_panel = ability_panel
	selected_ability = _panels_to_abilities[ability_panel]
	ability_selected.emit(selected_ability)


func _on_panel_deselected(ability_panel: AbilityPanel):
	_selected_panel = null
	ability_deselected.emit()
