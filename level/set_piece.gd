class_name SetPiece
extends Node2D

@export var health := 1
@export var item_type: Global.ItemType
@export var amount_dropped := 1
var item_scene: PackedScene

signal destroyed(item_to_spawn: Item, amount: int, coord: Vector2i)


func _ready():
	Battlefield.register_set_piece(self)
	destroyed.connect(Battlefield.add_items_at)
	item_scene = Global.item_types_to_scenes[item_type]


func damage(amount: int):
	health -= amount
	if health <= 0:
		visible = false
		var item = item_scene.instantiate()
		var coord = Battlefield.get_coord(global_position)
		destroyed.emit(item, amount_dropped, coord)
		visible = false


func heal(amount: int):
	health += amount
	if amount >= health:
		visible = true
