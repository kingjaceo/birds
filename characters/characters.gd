extends Node2D

var character_scene := load("res://characters/character.tscn")


#func _ready() -> void:
	#for character: Character in get_children():
		#var character_coords = %Main.local_to_map(character.position)
		#character.position = %Main.map_to_local(character_coords)


func setup(characters: Array[CharacterData]):
	for character in characters:
		var new_character = character_scene.instantiate()
		new_character.data = character
		new_character.position = %Main.map_to_local(Vector2i(randi_range(0, 10), randi_range(0, 10)))
		add_child(new_character)
