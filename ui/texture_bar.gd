extends HBoxContainer

@export var texture: Texture2D
var max_value := 1:
	set(new_value):
		max_value = new_value
		_set_min_size()
var value := 1:
	set(new_value):
		value = new_value
		_set_images()


func _set_min_size():
	custom_minimum_size.x = texture.get_width() * max_value


func _set_images():
	while get_children().size() < value:
		var texture_rect = TextureRect.new()
		texture_rect.texture = texture
		add_child(texture_rect)
	while get_children().size() > value:
		get_children()[0].free()
