class_name Level
extends Node2D

var paused: bool = false
@export var characters: Array[CharacterData]
signal quit_level_pressed
signal quit_game_pressed
signal restart_pressed


func _ready():
	%MainTrack.play()
	%Characters.setup(characters)


func _setup():
	print("setting the level up!")


func _input(event: InputEvent):
	if event.is_action_pressed("pause") and paused:
		_resume()
	elif event.is_action_pressed("pause") and not paused:
		_pause()


func _quit_level() -> void:
	quit_level_pressed.emit()


func _quit_game() -> void:
		get_tree().quit()


func _restart() -> void:
	restart_pressed.emit()
	if self == get_tree().current_scene:
		get_tree().reload_current_scene()


func _pause() -> void:
	%AbilitiesContainer.visible = false
	%Pause.visible = true
	paused = true


func _resume() -> void:
	%AbilitiesContainer.visible = true
	%Pause.visible = false
	paused = false
