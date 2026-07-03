extends Node2D


# locks characters onto the tilemap

# input state machine:
#  - states: nothing_selected, character_selected, ability_selectedd
#  - transitions:
#     nothing -> character: click on character
#     character -> nothing: right click anywhere
#     character -> ability: click ability card
#     ability -> character: right click anywhere
func _ready():
	#Engine.time_scale = 0.0
	$MainTrack.play()


func _on_play_pressed() -> void:
	Engine.time_scale = 1.0
	%MainMenu.visible = false


func _on_quit_pressed() -> void:
	get_tree().quit()
