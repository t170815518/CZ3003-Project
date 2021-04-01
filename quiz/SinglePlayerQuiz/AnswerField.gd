extends Control

# support question types 
const MCQ_TYPE = "mcq"
var correct_answer_id = -1

signal correct_answer
signal wrong_answer


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.connect("pressed", self, "check_if_correct") 


func update_question(description):
	$ItemList.add_item(description)


func clear_options():
	$ItemList.clear()


func check_if_correct():
	var selected_id = $ItemList.get_selected_items()
	if len(selected_id) == 0:  # no answer 
		print("Emit wrong answer")
		emit_signal("wrong_answer")
	else:
		if selected_id[0] == correct_answer_id:
			print("Emit correct answer")
			emit_signal("correct_answer")
		else:
			print("Emit wrong answer")
			emit_signal("wrong_answer")
