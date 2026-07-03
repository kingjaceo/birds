extends Node2D

#enum State {
	#NOTHING_SELECTED, 
	#CHARACTER_SELECTED,
	#ABILITY_SELECTED,
	#ABILITY_EXECUTING
	#}
#
#var current_state: State = State.NOTHING_SELECTED
#var current_character: Character
#var current_ability: Ability
#
#signal ability_selected(character: Character, ability: Ability)
#signal ability_activated(character: Character, ability: Ability)
#signal ability_deselected()
#
#
#func change_state(new_state: State):
	#_exit(current_state)
	#current_state = new_state
	#_enter(new_state)
#
#
#func _exit(state: State):
	#match state:
		#State.NOTHING_SELECTED:
			#pass
		#State.CHARACTER_SELECTED:
			#_deselect_characters()
		#State.ABILITY_SELECTED:
			#ability_deselected.emit()
			#_deselect_abilities()
		#State.ABILITY_EXECUTING:
			#_deselect_abilities()
			#_deselect_characters()
#
#
#func _enter(state: State):
	#match state:
		#State.NOTHING_SELECTED:
			#current_ability = null
			#current_character = null
		#State.CHARACTER_SELECTED:
			#pass
		#State.ABILITY_SELECTED:
			#for character: Character in %Characters.get_children():
				#character.set_clickable(false)
			#ability_selected.emit(current_character, current_ability)
		#State.ABILITY_EXECUTING:
			#ability_activated.emit(current_character, current_ability)
#
#
#func _unhandled_input(event):
	#if event.is_action_pressed("deselect"):
		#_deselect()
	#if event.is_action_pressed("select") and current_state == State.ABILITY_SELECTED:
		#get_viewport().set_input_as_handled()
		#change_state(State.ABILITY_EXECUTING)
#
#
#func _deselect():
	#match current_state:
		#State.ABILITY_SELECTED:
			#change_state(State.CHARACTER_SELECTED)
		#State.CHARACTER_SELECTED:
			#change_state(State.NOTHING_SELECTED)
#
#
#func _deselect_abilities():
	#for character: Character in %Characters.get_children():
		#character.deselect_abilities()
		#character.set_clickable(true)
	#ability_deselected.emit()
#
#
#func _deselect_characters():
	#for character: Character in %Characters.get_children():
		#if character != current_character:
			#character.deselect()
#
#
#func on_character_selected(character: Character) -> void:
	#current_character = character
	#change_state(State.CHARACTER_SELECTED)
#
#
#func on_ability_selected(ability: Ability) -> void:
	#current_ability = ability
	#change_state(State.ABILITY_SELECTED)
