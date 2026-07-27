class_name PlayerController
extends Controller


@export var allowed_abilities: int = 3
var abilities_history: Array[Dictionary] # {ability : state}
var effect_history: Array[Effect]

enum AbilityState {PLAYABLE, PLAYED, DISCARDED, REMOVED}

var all_abilities: Array[Ability]:
	get: return abilities_history[-1].keys().filter(
		func (ability): return abilities_history[-1][ability] in [AbilityState.PLAYABLE, AbilityState.PLAYED]
		)
var playable_abilities: Array[Ability]:
	get: return abilities_history[-1].keys().filter(
		func (ability): return abilities_history[-1][ability] == AbilityState.PLAYABLE
		)
var played_abilities: Array[Ability]:
	get: return abilities_history[-1].keys().filter(
		func (ability): return abilities_history[-1][ability] == AbilityState.PLAYED
	)

var abilities_played: int = 0: # replace UI changes with a signal and connect!
	set(value):
		if value == allowed_abilities:
			max_abilities_played.emit()
		abilities_played = value
		abilities_played_changed.emit(value)

signal abilities_played_changed(value: int)
signal max_abilities_played
signal history_changed
signal ability_discarded
signal ability_selected(ability: Ability)
signal ability_started
signal ability_finished
signal enabled
signal disabled


func setup():
	var all_abilities: Array[Ability]
	var first_abilities_dictionary: Dictionary[Ability, AbilityState]
	for character in %Characters.get_children():
		character.died.connect(_on_character_death.bind(character))
		character.respawned.connect(_on_character_respawn.bind(character))
		for ability in character.abilities:
			all_abilities.append(ability)
	for ability in all_abilities:
		first_abilities_dictionary[ability] = AbilityState.PLAYABLE
	_initialize_history(first_abilities_dictionary)
	


func take_turn():
	_enable()
	await turn_finished
	_fade_message("Discard an Ability . . .")
	await ability_discarded
	_disable()


func _enable():
	_fade_message("Player Turn . . .")
	abilities_played = 0
	enabled.emit()


func _disable():
	_fade_message("Player Turn Ended . . .")
	var new_history = abilities_history[-1].duplicate()
	for ability in played_abilities:
		new_history[ability] = AbilityState.PLAYABLE
	abilities_history.append(new_history)
	disabled.emit()


func _initialize_history(first_abilities_dictionary: Dictionary):
	abilities_history.append(first_abilities_dictionary)
	history_changed.emit()


func _undo():
	if abilities_played > 0:
		_rewind_abilities()
		var last_effect = effect_history.pop_back()
		await last_effect.reverse()
		abilities_played -= 1
		history_changed.emit()


func _rewind_abilities():
	abilities_history.pop_back()
	history_changed.emit()


func _play_ability(ability: Ability):
	var new_abilities_dictionary = abilities_history[-1].duplicate()
	new_abilities_dictionary[ability] = AbilityState.PLAYED
	abilities_history.append(new_abilities_dictionary)


func _discard_ability(ability: Ability):
	var new_abilities_dictionary = abilities_history[-1].duplicate()
	new_abilities_dictionary[ability] = AbilityState.DISCARDED
	abilities_history.append(new_abilities_dictionary)
	ability_discarded.emit()
	history_changed.emit()


func _apply_effect(ability: Ability, target_coords: Array[Vector2i]):
	var caster_coord = Battlefield.get_coord(ability.character.global_position)
	var effect = ability.effect.duplicate()
	effect_history.append(effect)
	await effect.apply(ability.character, caster_coord, target_coords)


func _on_character_death(character: Character):
	var new_abilities_dictionary = abilities_history[-1].duplicate()
	for ability in character.abilities:
		new_abilities_dictionary[ability] = AbilityState.REMOVED
	abilities_history.append(new_abilities_dictionary)


func _on_character_respawn(character: Character):
	abilities_history.pop_back()


func on_ability_executed(ability: Ability, target_coords: Array[Vector2i]):
	_play_ability(ability)
	abilities_played += 1
	ability_started.emit()
	await _apply_effect(ability, target_coords)
	ability_finished.emit()
	if abilities_played == allowed_abilities:
		_set_playable_abilities_unplayable()
	history_changed.emit()


func _set_playable_abilities_unplayable():
	for ability in playable_abilities:
		abilities_history[-1][ability] = AbilityState.PLAYED


func _on_turn_finished() -> void:
	turn_finished.emit()
