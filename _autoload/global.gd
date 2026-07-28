extends Node

var item_types_to_scenes = {
	ItemType.MATERIAL: load("res://items/item.tscn")
}

enum ItemType {EGG, FEATHER, MATERIAL, BEAD}

func tween():
	return get_tree().create_tween()
