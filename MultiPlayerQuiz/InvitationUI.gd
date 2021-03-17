extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var quizID = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	$CreateQuizButton.connect("pressed", self, "request_create_quiz")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func request_create_quiz():
	$"/root/Network".post_create_room_request()
	
