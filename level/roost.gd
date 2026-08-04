extends Node2D


func _ready():
	%CharacterDisplayContainer.character = load("res://characters/cardinal.tscn").instantiate()
