class_name Character
extends Node2D

@export var max_health: int = 5
@onready var health: int = max_health:
	set(value):
		health = clampi(value, 0, max_health)
		%Healthbar.value = health
@export var abilities: Array[Ability]
var selected := false
var dead := false

signal died
signal respawned


func _ready():
	Battlefield.register_character(self)
	for ability in abilities:
		ability.character = self
	%Healthbar.max_value = max_health
	%Healthbar.value = max_health


func damage(amount: int):
	health -= amount
	if health <= 0:
		die()


func heal(amount: int):
	health += amount
	if dead:
		dead = false
		respawned.emit()
	visible = true


func die():
	dead = true
	visible = false
	died.emit()



func play_walk():
	pass
	#$AnimatedSprite2D.play("walk")


func highlight():
	if not selected:
		$Sprite2D.modulate = Color.DARK_SLATE_GRAY


func unhighlight():
	if not selected:
		$Sprite2D.modulate = Color.WHITE


func select():
	$Sprite2D.modulate = Color.GREEN
	selected = true


func deselect():
	$Sprite2D.modulate = Color.WHITE
	selected = false
