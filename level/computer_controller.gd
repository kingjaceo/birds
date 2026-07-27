class_name Controller
extends Node2D

signal turn_finished
signal game_over_triggered


func setup():
	print("Default Controller has no setup.")


func take_turn():
	_enable()
	print("Default Controller has no turn.")
	await get_tree().create_timer(1.0).timeout
	_disable()


func _enable():
	_fade_message("Default Controller Turn . . .")


func _disable():
	$CanvasLayer.visible = false
	print("Default Controller has no disable.")


func _fade_message(message: String):
	$CanvasLayer/Label.modulate = Color.WHITE
	$CanvasLayer/Label.visible = true
	$CanvasLayer/Label.text = message
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/Label, "modulate", Color.TRANSPARENT, 4.0)
	await tween.finished
	$CanvasLayer/Label.visible = false
	
	
