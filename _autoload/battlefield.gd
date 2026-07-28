extends Node

var targets: Dictionary[Node2D, Vector2i]
var layers: Array[BattlefieldLayer]
var _ground: BattlefieldLayer:
	get: return layers[0]
var _set: BattlefieldLayer:
	get: return layers[1]
var _items: BattlefieldLayer:
	get: return layers[2]


func register_layer(layer: BattlefieldLayer):
	layers.append(layer)


func register_character(character: Character):
	var target_coord = _ground.local_to_map(_ground.to_local(character.global_position))
	targets[character] = target_coord


func register_set_piece(set_piece: SetPiece):
	var target_coord = _ground.local_to_map(_ground.to_local(set_piece.global_position))
	targets[set_piece] = target_coord


func get_targets_at(coords: Array[Vector2i]) -> Array[Node2D]:
	return targets.keys().filter(
		func (target): return targets[target] in coords
	)


func get_position(coord: Vector2i) -> Vector2:
	return _ground.to_global(_ground.map_to_local(coord))


func get_coord(_global_position: Vector2) -> Vector2i:
	return _ground.local_to_map(_ground.to_local(_global_position))


func add_items_at(item: Item, amount: int, coord: Vector2i):
	for i in range(amount):
		var new_coord = _items.find_nearest_clear_cell(coord)
		var new_item = item.duplicate()
		new_item.global_position = _items.to_global(_items.map_to_local(new_coord))
		_items.add_child(new_item)
	item.free()
