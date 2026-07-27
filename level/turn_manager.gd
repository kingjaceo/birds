extends Node2D

# TODO: refactor
# - rig a state machine to manage moving between components
# - the abilities Arrays could have linked "history" arrays: instead of appending / erasing, you could just create a duplicate, add it to the history array; on "undo", just pop off the back and reset to the last element
enum PlayerType {HUMAN, COMPUTER}

var current_child: Controller
var current_index: int
var rounds_played: int
var game_over := false


func _ready():
	_setup()
	current_index = 0
	current_child = get_child(current_index)
	while not game_over:
		await current_child.take_turn()
		current_index = (current_index + 1) % get_children().size()
		current_child = get_child(current_index)
		if current_index == 0:
			rounds_played += 1


func _setup():
	for controller: Controller in get_children():
		controller.game_over_triggered.connect(_game_over)
		controller.setup()


func _game_over():
	game_over = true
	print("game over!")
	%GameOver.visible = true
