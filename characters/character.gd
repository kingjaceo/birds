class_name Character
extends Node2D

@export var max_health: int = 5
var health: int = max_health:
	set(value):
		health = clampi(value, 0, max_health)
		%Healthbar.value = health
@export var abilities: Array[Ability]
var selected := false
var dead := false

func _ready():
	%Healthbar.max_value = health
	%Healthbar.value = health
	


func damage(amount: int):
	health -= amount
	if health <= 0:
		die()


func heal(amount: int):
	health += amount
	dead = false
	visible = true


func die():
	dead = true
	visible = false



func play_walk():
	pass
	#$AnimatedSprite2D.play("walk")


func highlight():
	if not selected:
		self_modulate = Color.DARK_SLATE_GRAY


func unhighlight():
	if not selected:
		self_modulate = Color.WHITE


func select():
	self_modulate = Color.GREEN
	selected = true


func deselect():
	self_modulate = Color.WHITE
	selected = false
#var is_selected := false
#var is_clickable := true

#signal selected(character: Character)
#signal ability_selected(ability: Ability)


#func _ready():
	#%Abilities.setup(abilities)
	#for ability_panel: AbilityPanel in %Abilities.get_children():
		#ability_panel.selected.connect(ability_selected.emit)


#func _on_area_2d_mouse_entered() -> void:
	#if not is_selected and is_clickable:
		#modulate = Color.DARK_SLATE_GRAY
#
#
#func _on_area_2d_mouse_exited() -> void:
	#if not is_selected:
		#modulate = Color.WHITE
#
#
#func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event.is_action_pressed("select") and not is_selected and is_clickable:
		#_select()


#func _select():
	#modulate = Color.DARK_GREEN
	#is_selected = true
	#selected.emit(self)
	#$CharacterUI.visible = true


#func deselect():
	#is_selected = false
	#$CharacterUI.visible = false
	#modulate = Color.WHITE
	#deselect_abilities()


#func deselect_abilities():
	#for ability_panel: AbilityPanel in %Abilities.get_children():
		#ability_panel.deselect()
#
#
#func set_clickable(value: bool):
	#is_clickable = value
