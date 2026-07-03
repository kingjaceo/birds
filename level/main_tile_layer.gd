extends TileMapLayer


func _ready():
	Battlefield.set_tilemap(self)


func is_targetable_tile(coord: Vector2i):
	if coord in get_used_cells():
		var terrain = get_cell_tile_data(coord).terrain
		return terrain == 0


func target_at(coord):
	for character: Character in %Characters.get_children():
		if coord == local_to_map(character.global_position):
			return character
