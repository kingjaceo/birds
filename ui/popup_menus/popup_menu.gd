extends PanelContainer

signal button1_pressed
signal button2_pressed
signal button3_pressed


func _on_button1_pressed() -> void:
	button1_pressed.emit()


func _on_button2_pressed() -> void:
	button2_pressed.emit()


func _on_button3_pressed() -> void:
	button3_pressed.emit()
