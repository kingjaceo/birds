class_name TurnState
extends Resource

var _available_abilities: Array[Ability]
var _used_abilities: Array[Ability]
var _discarded_abilities: Array[Ability]
var _history: Array[Effect]


func unod():
	print("I need to undo the last history item, update everything, and signal out!")
