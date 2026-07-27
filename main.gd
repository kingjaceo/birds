class_name Main
extends Node2D

var quickplay_scene: PackedScene = load("res://level.tscn")
var draft_play_scene: PackedScene
var campaign_scene: PackedScene
var current_level_scene: PackedScene
var current_level: Level

func _quickplay():
	_load_level(quickplay_scene)


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


func _on_level_quit():
	current_level.queue_free()
	current_level = null
	%MainMenu.visible = true


func _on_level_restart():
	_load_level(current_level_scene)
	


func _quit() -> void:
	get_tree().quit()
