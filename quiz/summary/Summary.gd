extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_win = true
var time = "0:00"
var total_questions = 10
var correct_answers = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 
	

func refresh():
	# set background 
	# print("Loading " + background_path)
	# var background_node = load(background_path).instance()
	# self.add_child(background_node)
	# self.move_child(background_node, 0) # re-order the scene to the end 
	
	if is_win:
		$Title.set_text("Congratulations! You win the quiz!")
	else:
		$Title.set_text("Oops! Wish you good luck next time!")
	$TotalTime.set_text(str(time))
	$TotalAnswer.set_text(str(total_questions))
	$CorrectAnswer.set_text(str(correct_answers))
	$OKButton.connect("pressed", self, "_on_pressed_ok")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
