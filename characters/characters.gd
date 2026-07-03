extends Node2D


func _ready() -> void:
	for character: Character in get_children():
		var character_coords = %Main.local_to_map(character.position)
		character.position = %Main.map_to_local(character_coords)
