extends Node

var _ground: TileMapLayer

func set_tilemap(tilemap: TileMapLayer):
	_ground = tilemap


func get_targets_at(coords: Array[Vector2i]) -> Array[Node2D]:
	var targets: Array[Node2D]
	for coord in coords:
		var target = _ground.target_at(coord)
		if target:
			targets.append(target)
	return targets


func get_position(coord: Vector2i) -> Vector2:
	return _ground.to_global(_ground.map_to_local(coord))
