extends Control


# Declare member variables here. Examples:
export var topic_url = "https://ssad-api.herokuapp.com/api/v1/list/topic"
var topic_ids = []


# Called when the node enters the scene tree for the first time.
func _ready():
	# connect signals 
	$HTTPRequest.connect("request_completed", self, "_refresh_topic_list")
	$SubmitSelection.connect("pressed", self, "submit_selection")
	
	$PopupDialog.popup_centered()
	
	# fetch topic 
	$HTTPRequest.request(topic_url, [])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _refresh_topic_list(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			body = JSON.parse(body.get_string_from_utf8()).result
			for topic in body:
				print(topic)
				topic_ids.append(topic["_id"])
				$TopicList.add_item(topic["topic_name"])
			remove_child($PopupDialog)


func submit_selection():
	var selections = $TopicList.get_selected_items()  # selection is length of 1
	var topic_id = topic_ids[selections[0]]
	print(topic_id)  # for log-in info 
	# change scene to quiz 
	var next_scene = preload("res://quiz/QuizSelection/QuizSelectionUI.tscn").instance()
	next_scene.topic_id = topic_id
	var root = get_tree().get_root()
	root.remove_child(self)
	root.add_child(next_scene)

