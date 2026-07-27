class_name AbilityManager
extends Node2D

@export var main_layer: TileMapLayer
@export var range_overlay: TileMapLayer
@export var area_overlay: TileMapLayer
@export var controller: PlayerController
var range_coords: Array[Vector2i]
var area_coords: Array[Vector2i]
var target_center: Vector2i
var target_coords: Array[Vector2i]
var discard_mode: bool = false
var _selected_ability: Ability
var disabled := false

signal ability_executed(ability: Ability, target_coords: Vector2i)


func _ready():
	controller.enabled.connect(_enable)
	controller.turn_finished.connect(_disable)
	ability_executed.connect(controller.on_ability_executed)


func _enable():
	disabled = false


func _disable():
	_clear()
	if not disabled:
		disabled = true


func _clear():
	range_overlay.clear()
	area_overlay.clear()
	_selected_ability = null


func _on_ability_selected(ability: Ability):
	_clear()
	_selected_ability = ability
	if not disabled:
		display_ability_range(ability)
		display_ability_area(ability)


func display_ability_range(ability):
	range_overlay.clear()
	var character_coord = main_layer.local_to_map(ability.character.position)
	var range_image = ability.range.get_image()
	range_coords = []
	var offset = character_coord - Vector2i(7, 7)
	for x in range_image.get_width():
		for y in range_image.get_height():
			var pixel = range_image.get_pixel(x, y)
			var coord = Vector2i(x, y) + offset
			if pixel == Color.RED and main_layer.is_targetable_tile(coord):
				range_coords.append(coord)
	for range_coord in range_coords:
		range_overlay.set_cell(range_coord, 0, Vector2i(0, 0), 1)


func display_ability_area(ability):
	area_overlay.clear()
	area_coords = []
	var area_image = ability.area.get_image()
	var offset = Vector2i(7, 7)
	for x in area_image.get_width():
		for y in area_image.get_height():
			var pixel = area_image.get_pixel(x, y)
			if pixel == Color.BLUE:
				area_coords.append(Vector2i(x, y) - offset)
	for area_coord in area_coords:
		area_overlay.set_cell(area_coord, 0, Vector2i(0, 0), 2)


func _unhandled_input(event: InputEvent):
	if _selected_ability and not disabled:
		if event.is_action_pressed("select"):
			ability_executed.emit(_selected_ability, target_coords.duplicate())
			_clear()
			get_viewport().set_input_as_handled()


func _process(_delta):
	if range_coords.size() > 0:
		var mouse_coord = main_layer.local_to_map(get_local_mouse_position())
		var new_center = TilemapUtilities.nearest_tile_to(range_coords, mouse_coord)
		if new_center != target_center:
			target_center = new_center
			target_coords.clear()
			for area_coord in area_coords:
				target_coords.append(area_coord + target_center)
		area_overlay.global_position = main_layer.map_to_local(target_center) - Vector2(8, 8)


func _on_ability_deselected() -> void:
	_clear()
