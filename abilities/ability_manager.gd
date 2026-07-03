extends Node2D

enum State {
	INACTIVE,
	AWAITING_INPUT,
	EXECUTING
}

var current_state: State
var range_coords: Array[Vector2i]
var area_coords: Array[Vector2i]
var current_character: Character
var current_ability: Ability
var history: Array[Effect]

signal ability_finished


func select_ability(character: Character, ability: Ability):
	current_state = State.AWAITING_INPUT
	current_character = character
	current_ability = ability
	if ability.range and ability.area:
		_set_up_range(character, ability)
		_set_up_area(ability)


func _unhandled_input(event: InputEvent):
	if current_state == State.AWAITING_INPUT:
		if event.is_action_pressed("select"):
			_execute_ability()
			get_viewport().set_input_as_handled()
		if event.is_action_pressed("deselect"):
			$Range.clear()
			$Area.clear()


func _process(_delta):
	if range_coords.size() > 0:
		var mouse_coords = %Main.local_to_map(get_local_mouse_position())
		var coords = TilemapUtilities.nearest_tile_to(range_coords, mouse_coords)
		$Area.global_position = %Main.map_to_local(coords) - Vector2(8, 8)


func _set_up_range(character: Character, ability: Ability):
	$Range.clear()
	var character_coord = %Main.local_to_map(character.position)
	var range_image = ability.range.get_image()
	range_coords = []
	var offset = character_coord - Vector2i(7, 7)
	for x in range_image.get_width():
		for y in range_image.get_height():
			var pixel = range_image.get_pixel(x, y)
			var coord = Vector2i(x, y) + offset
			if pixel == Color.RED and %Main.is_targetable_tile(coord):
				range_coords.append(coord)
	for range_coord in range_coords:
		$Range.set_cell(range_coord, 0, Vector2i(0, 0), 1)


func _set_up_area(ability: Ability):
	$Area.clear()
	area_coords = []
	var area_image = ability.area.get_image()
	var offset = Vector2i(7, 7)
	for x in area_image.get_width():
		for y in area_image.get_height():
			var pixel = area_image.get_pixel(x, y)
			if pixel == Color.BLUE:
				area_coords.append(Vector2i(x, y) - offset)
	for area_coord in area_coords:
		$Area.set_cell(area_coord, 0, Vector2i(0, 0), 2)


func _execute_ability():
	var caster_coord = %Main.local_to_map(current_character.global_position)
	var target_coord = %Main.local_to_map(get_global_mouse_position())
	current_state = State.EXECUTING
	target_coord = TilemapUtilities.nearest_tile_to(range_coords, target_coord)
	var target_position = %Main.map_to_local(target_coord)
	var target_coords: Array[Vector2i]
	for area_coord in area_coords:
		target_coords.append(area_coord + target_coord)
	$Range.clear()
	$Area.clear()
	var effect: Effect = current_ability.effect.duplicate()
	var tween = get_tree().create_tween()
	await effect.apply(current_character, caster_coord, target_coords, tween)
	current_state = State.INACTIVE
	history.append(effect)
	ability_finished.emit()


func is_executing():
	return current_state == State.EXECUTING


func _undo() -> void:
	if history.is_empty():
		return
	# pop the last element off history
	var last_effect = history.pop_back()
	last_effect.reverse()
