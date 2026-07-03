class_name EffectAnimation
extends AnimatedSprite2D


signal finished


func travel():
	play("travel")
	$Travel.play()

func execute():
	$Travel.stop()
	await get_tree().create_timer(0.15).timeout
	play("execute")
	$Execute.play()
	await get_tree().create_timer(2.5).timeout
	finished.emit()
