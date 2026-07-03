class_name Effect
extends Resource

var _caster: Character
var _caster_coord: Vector2i
var _target_coords: Array[Vector2i]
var _targets: Array[Node2D]
var _tween: Tween


func apply(caster: Character, caster_coord: Vector2i, target_coords: Array[Vector2i], tween: Tween):
	_caster = caster
	_caster_coord = caster_coord
	_target_coords = target_coords
	_targets = Battlefield.get_targets_at(_target_coords)
	_tween = tween
	await _do_apply()


func _do_apply():
	push_warning("effect with no apply() function!!")
