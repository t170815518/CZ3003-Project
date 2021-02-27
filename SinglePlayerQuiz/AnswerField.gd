extends Control

# support question types 
const MCQ_TYPE = "mcq"

# Declare member variables here. Examples:
var option1
var option2
var option3
var option4


# Called when the node enters the scene tree for the first time.
func _ready():
	update_questions("mcq")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_questions(type):
	if type == MCQ_TYPE:
		option1 = Button.new()
		option1.set_position(Vector2(64, 256))
		add_child(option1)
		option2 = Button.new()
		option2.set_position(Vector2(320, 256))
		add_child(option2)
		option3 = Button.new()
		option3.set_position(Vector2(574, 256))
		add_child(option3)
		option4 = Button.new()
		option4.set_position(Vector2(704, 256))
		add_child(option4)
	else:
		pass 
