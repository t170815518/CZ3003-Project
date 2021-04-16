extends Control

# support question types 
const MCQ_TYPE = "mcq"
var correct_answer_id = -1

signal correct_answer(option)
signal wrong_answer(option)


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.connect("pressed", self, "check_if_correct") 


func update_question(description):
	$ItemList.add_item(description)


func clear_options():
	$ItemList.clear()


func check_if_correct():
	var selected_id = $ItemList.get_selected_items()
	$Text
	if len(selected_id) == 0:  # no answer 
		print("Emit wrong answer")
		emit_signal("wrong_answer", -1)
	else:
		if selected_id[0] == correct_answer_id:
			print("Emit correct answer")
			emit_signal("correct_answer", selected_id[0])
		else:
			print("Emit wrong answer")
			emit_signal("wrong_answer", selected_id[0])
