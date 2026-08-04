class_name BattlefieldLayer
extends TileMapLayer


func _ready():
	Battlefield.register_layer(self)


func is_targetable_tile(coord: Vector2i):
	if coord in get_used_cells():
		var terrain = get_cell_tile_data(coord).terrain
		return terrain == 0
	return false
	#return true


func target_at(coord):
	var tile = get_cell_tile_data(coord)
	return tile


func find_nearest_clear_cell(coord: Vector2i):
	var current_radius := 0
	var max_radius := 10
	while current_radius <= max_radius:
		for candidate in _ring_coords(coord, current_radius):
			if not candidate in get_used_cells(): # potentially slow
				return candidate
		current_radius += 1


func _ring_coords(coord: Vector2i, radius: int) -> Array[Vector2i]:
	var coords: Array[Vector2i]
	for x in range(-radius, radius + 1):
		coords.append(coord + Vector2i(x, -radius))
		coords.append(coord + Vector2i(x, radius))
	for y in range(-radius + 1, radius):
		coords.append(coord + Vector2i(-radius, y))
		coords.append(coord + Vector2i(radius, y))
	return coords
