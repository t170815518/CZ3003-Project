extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var topic_url = "https://ssad-api.herokuapp.com/api/v1/topic/quizzes/"
var quiz_ids = []
var topic_id = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	# connect signals 
	$HTTPRequest.connect("request_completed", self, "_refresh_quiz_list")
	$SubmitSelection.connect("pressed", self, "submit_selection")
	
	$PopupDialog.popup_centered()
	
	# fetch topic 
	$HTTPRequest.request(topic_url + topic_id, [])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _refresh_quiz_list(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			body = JSON.parse(body.get_string_from_utf8()).result
			for quiz in body["quizzes"]:
				print(quiz)
				quiz_ids.append(quiz["_id"])
				$QuizList.add_item(quiz["quiz_name"])
			remove_child($PopupDialog)


func submit_selection():
	var selections = $QuizList.get_selected_items()  # selection is length of 1
	var topic_id = quiz_ids[selections[0]]
	print(topic_id)  # for log-in info 
	# change scene to quiz 
	var next_scene = preload("res://quiz/SinglePlayerQuiz/QuizField.tscn").instance()
	next_scene.topic_id = topic_id
	var root = get_tree().get_root()
	root.remove_child(self)
	root.add_child(next_scene)
