class_name Ability
extends Resource

@export var name: String
@export var icon: Texture
@export var range: Texture2D
@export var area: Texture2D
@export var effect: Effect = Effect.new()
var character: Character

#signal selected
#signal deselected
#signal executed(target_coords: Array[Vector2i])
