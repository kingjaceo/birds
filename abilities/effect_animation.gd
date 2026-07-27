class_name EffectAnimation
extends Node2D


signal finished


func travel():
	$AnimatedSprite2D.play("travel")
	$Travel.play()

func execute():
	$Travel.stop()
	await get_tree().create_timer(0.15).timeout
	$AnimatedSprite2D.play("execute")
	$Execute.play()
	await $AnimatedSprite2D.animation_finished
	finished.emit()
