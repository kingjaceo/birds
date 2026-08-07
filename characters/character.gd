class_name Character
extends Node2D

@export var max_health: int = 5
var health: int:
	set(value):
		health = clampi(value, 0, data.max_health)
		%Healthbar.value = health
@export var abilities: Array[Ability]
var data: CharacterData
var selected := false
var dead := false

signal died
signal respawned


func _ready():
	$Sprite2D.texture = data.icon
	health = data.max_health
	Battlefield.register_character(self)
	for ability in data.abilities:
		ability.character = self
	%Healthbar.max_value = data.max_health
	%Healthbar.value = data.max_health


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
