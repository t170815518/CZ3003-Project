extends Control

# support question types 
const MCQ_TYPE = "mcq"

# Declare member variables here. Examples:
var option1
var option2
var option3
var option4

signal correct_answer 
signal wrong_answer 


# Called when the node enters the scene tree for the first time.
func _ready():
	update_questions("mcq")


func update_questions(type):
	if type == MCQ_TYPE:
		option1 = Button.new()
		option1.set_position(Vector2(64, 256))
		add_child(option1)
		option1.connect("pressed", self, "_on_Player_press_button", [1])
		option2 = Button.new()
		option2.set_position(Vector2(320, 256))
		add_child(option2)
		option2.connect("pressed", self, "_on_Player_press_button", [2])
		option3 = Button.new()
		option3.set_position(Vector2(574, 256))
		add_child(option3)
		option3.connect("pressed", self, "_on_Player_press_button", [3])
		option4 = Button.new()
		option4.set_position(Vector2(704, 256))
		add_child(option4)
		option4.connect("pressed", self, "_on_Player_press_button", [4])
	else:
		pass 


# check if the answer is correct for MCQ question 
func _on_Player_press_button(index):	
	print("User clicks button", index)
	if index == 4:  # assume the correct answer is 4 
		emit_signal("correct_answer")
	else:
		emit_signal("wrong_answer")
