class_name DamageEffect
extends Effect

@export var damage: int = 2
@export var animation_scene: PackedScene
@export var speed: float = 5.0 # tiles per second
@export var reverse_speed: float = speed * 3


func _description():
	return str(damage) + " Damage"


func _do_apply():
	if animation_scene:
		await _animate()
	for target in _targets:
		target.damage(damage)


func _do_reverse():
	for target in _targets:
		target.heal(damage)
	await _reverse_animate()


func _animate():
	var start_position = Battlefield.get_position(_caster_coord)
	var middle_coord = _target_coords[int(_target_coords.size() / 2)]
	var stop_position = Battlefield.get_position(middle_coord)
	var distance = middle_coord.distance_to(_caster_coord)
	var time = distance / speed
	var animation = animation_scene.instantiate()
	# set position
	_caster.add_child(animation)
	animation.global_position = start_position
	# set rotation
	var angle = Vector2(0, -1).angle_to(stop_position - start_position)
	animation.rotation = angle
	var tween = _caster.create_tween()
	tween.tween_property(animation, "global_position", stop_position, time)
	animation.travel()
	await tween.finished
	# play execution
	animation.execute()
	await animation.finished
	animation.queue_free()


func _reverse_animate():
	var start_position = Battlefield.get_position(_caster_coord)
	var middle_coord = _target_coords[int(_target_coords.size() / 2)]
	var stop_position = Battlefield.get_position(middle_coord)
	var distance = middle_coord.distance_to(_caster_coord)
	var time = distance / reverse_speed
	if animation_scene:
		var animation = animation_scene.instantiate()
		# set position
		_caster.add_child(animation)
		animation.global_position = stop_position
		# set rotation
		var angle = Vector2(0, -1).angle_to(stop_position - start_position)
		animation.rotation = angle
		var tween = _caster.create_tween()
		tween.tween_property(animation, "global_position", start_position, time)
		animation.travel()
		await tween.finished
		animation.queue_free()
