class_name Main
extends Node2D

var quickplay_scene: PackedScene = load("res://level/level.tscn")
var roost_scene: PackedScene = load("res://level/roost.tscn")
var campaign_scene: PackedScene
var current_level_scene: PackedScene
var current_level: Level
var roost: Roost


func _quickplay():
	_load_level(quickplay_scene)


func _load_roost() -> void:
	%MainMenu.visible = false
	if current_level:
		current_level.queue_free()
	roost = roost_scene.instantiate()
	roost.mission_and_party_selected.connect(_load_mission_with_party)
	add_child(roost)


func _load_level(scene: PackedScene):
	%MainMenu.visible = false
	if current_level:
		#current_level.quit_pressed.disconnect(_on_level_quit)
		#current_level.restart_pressed.disconnect(_on_level_restart)
		current_level.queue_free()
	current_level_scene = scene
	current_level = current_level_scene.instantiate()
	current_level.quit_level_pressed.connect(_on_level_quit)
	current_level.quit_game_pressed.connect(_quit)
	current_level.restart_pressed.connect(_on_level_restart)
	add_child(current_level)


func _load_mission_with_party(mission: PackedScene, party: Array[CharacterData]):
	roost.queue_free()
	%MainMenu.visible = false
	current_level_scene = mission
	current_level = current_level_scene.instantiate()
	current_level.quit_level_pressed.connect(_on_level_quit)
	current_level.quit_game_pressed.connect(_quit)
	current_level.restart_pressed.connect(_on_level_restart)
	current_level.characters = party
	add_child(current_level)


func _on_level_quit():
	current_level.queue_free()
	current_level = null
	%MainMenu.visible = true


func _on_level_restart():
	_load_level(current_level_scene)
	


func _quit() -> void:
	get_tree().quit()
