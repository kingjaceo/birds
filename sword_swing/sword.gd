extends Node2D

var is_swinging: bool = false
var is_shooting: bool = false
var shoot_cooldown: float = 1.0
var projectile_scene: PackedScene = load("res://sword_swing/projectile.tscn")


func swing():
	if not is_swinging:
		# rotate the sword back and forth really quickly
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", 45, 0.25).from(135)
		is_swinging = true
		await tween.finished
		is_swinging = false


func shoot():
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	if Input.is_action_pressed("ui_left"):
		projectile.rotation_degrees = 180


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		self.reparent(body)
		position = Vector2(45, 35)
		rotation_degrees = 90
	if body.is_in_group("enemy"):
		body.damage()
