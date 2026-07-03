extends Node


func nearest_tile_to(coords: Array[Vector2i], target: Vector2i) -> Vector2i:
	var closest_tile = coords[0]
	var min_distance = closest_tile.distance_to(target)
	for coord in coords:
		var distance = coord.distance_to(target)
		if distance < min_distance:
			min_distance = distance
			closest_tile = coord
	return closest_tile
