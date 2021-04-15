extends Control

# support question types 
const MCQ_TYPE = "mcq"
var correct_answer_id = -1

signal correct_answer(option)
signal wrong_answer(option)
signal post_answer(option, desc)


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.connect("pressed", self, "post_attempt") 


func update_question(description):
	$ItemList.add_item(description)


func clear_options():
	$ItemList.clear()


func post_attempt():
	var selected_id = $ItemList.get_selected_items()
	if len(selected_id) == 0:  # no answer 
		print("Emit wrong answer")
		emit_signal("post_answer", -1, "")
	else:
		emit_signal("post_answer", selected_id[0], $ItemList.get_item_text(selected_id[0]))
