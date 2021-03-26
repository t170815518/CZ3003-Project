extends Control

# support question types 
const MCQ_TYPE = "mcq"

# Declare member variables here. Examples:

signal correct_answer 
signal wrong_answer 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


func update_questions(option_num, type="mcq"):
	if type == MCQ_TYPE:
		var h = 15 + self.get_position()[0]
		var offset = self.get_size()[0] / option_num
		var v = self.get_size()[1] + self.get_position()[1]
		var options = []
		for i in range(option_num):
			var option = Button.new()
			option.set_position(Vector2(h + offset * i, v / 2))
			add_child(option)
			options.append(option)
		return options
	else:
		pass 


# check if the answer is correct for MCQ question 
func _on_Player_press_button(index):	
	print("User clicks button", index)
	if index == 4:  # assume the correct answer is 4 
		emit_signal("correct_answer")
	else:
		emit_signal("wrong_answer")
