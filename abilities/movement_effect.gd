class_name MovementEffect
extends Effect

var speed: float = 3.0 # tiles per second


func _do_apply():
	# play walk animation
	# tween character to only target tile
	# ** ONLY IF THE TILE IS EMPTY ** ??
	#    OTHERWISE THE EFFECT FAILS SOMEHOW?
	#    or effect determine their own "valid target coords" as well!
	_caster.play_walk()
	var target_coord = _target_coords[0]
	var target_position = Battlefield.get_position(target_coord)
	var distance = target_coord.distance_to(_caster_coord)
	var time = speed / distance
	_tween.tween_property(_caster, "global_position", target_position, time)


func reverse():
	_caster.global_position = Battlefield.get_position(_caster_coord)
