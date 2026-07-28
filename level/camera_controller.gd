extends Camera2D

@export var base_speed: float = 60.0
@export var sprint_factor: float = 3.0


func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	var speed = base_speed
	if Input.is_action_pressed("up"):
		direction += Vector2(0, -1)
	if Input.is_action_pressed("down"):
		direction += Vector2(0, 1)
	if Input.is_action_pressed("sprint"):
		speed *= sprint_factor
	position += direction * speed * delta
