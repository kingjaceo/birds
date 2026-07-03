extends HBoxContainer


func _process(_delta):
	$Label2.text = str(roundf(%Timer.time_left)) + " s"
