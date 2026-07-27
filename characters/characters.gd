extends Node2D

#signal character_died(character: Character)
#signal character_respawned(character: Character)


func _ready() -> void:
	for character: Character in get_children():
		var character_coords = %Main.local_to_map(character.position)
		character.position = %Main.map_to_local(character_coords)
		#character.died.connect(character_died.emit.bind(character))
		#character.died.connect(_on_character_death.bind(character))
		#character.respawned.connect(character_respawned.emit.bind(character))
