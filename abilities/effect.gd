class_name Effect
extends Resource

var description: String:
	get: return _description()
var _caster: Character
var _caster_coord: Vector2i
var _target_coords: Array[Vector2i]
var _targets: Array[Node2D]


func _description():
	return "N/A"


func apply(caster: Character, caster_coord: Vector2i, target_coords: Array[Vector2i]):
	_caster = caster
	_caster_coord = caster_coord
	_target_coords = target_coords
	_targets = Battlefield.get_targets_at(_target_coords)
	await _do_apply()


func _do_apply():
	push_warning("Effect has no apply() function.")


func reverse():
	await _do_reverse()


func _do_reverse():
	push_warning("Effect has no reverse() function.")
