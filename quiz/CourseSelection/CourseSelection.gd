extends Control


# Declare member variables here. Examples:
var course_url = "https://ssad-api.herokuapp.com/api/v1/course_all"
var topic_url = "https://ssad-api.herokuapp.com/api/v1/list/topic"
var current_course_id = -1  # for browsing courses from 0 
var course_ids = []
var course_names = []
var topics_dict = {}
var topics = [] 
var background_node = null
var background_path = ""

const BACKGROUND_ID_UPPER_LIMIT = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	# connect signals 
	$CourseHTTPRequest.connect("request_completed", self, "_refresh_course_list")
	$TopicListHTTPRequest.connect("request_completed", self, "TopicListHTTPRequest_list")
	$SubmitSelection.connect("pressed", self, "submit_selection")
	$LeftButton.connect("pressed", self, "fresh_topic_list_left")
	$RightButton.connect("pressed", self, "fresh_topic_list_right")
	
	# display loading dialog
	$PopupDialog.popup_centered()

	$CourseHTTPRequest.request(course_url, [])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Loads information of course and topics 
func _refresh_course_list(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			body = JSON.parse(body.get_string_from_utf8()).result
			for course in body["courses"]:
				print(course)
				course_ids.append(course["_id"])
				course_names.append(course["course_name"])
				topics.append(course["topic_list"]) #topics is an array that stores multiple arrays
			$TopicListHTTPRequest.request(topic_url)

	else:
		print("Http Request fails")
			

func TopicListHTTPRequest_list(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			body = JSON.parse(body.get_string_from_utf8()).result
			for topic in body:
				for array1 in topics:
					for item in array1:
						if item == topic["_id"]:
							topics_dict[topic["_id"]] = topic["topic_name"]
			remove_child($PopupDialog)
			# display the first course by default 
			fresh_topic_list_right()

	else:
		print("Http Request fails")


# to display the topics of a course
func fresh_topic_list_right():
	# randomize background 
	if background_node != null:
		self.remove_child(background_node)
	var random_background_id = randi() % BACKGROUND_ID_UPPER_LIMIT
	background_path = "res://assets/background/background_%s.tscn" % (str(random_background_id))
	print("Loading " + background_path)
	background_node = load(background_path).instance()
	self.add_child(background_node)
	self.move_child(background_node, 0) # re-order the scene to the end 
	
	# cylindral selection 
	if current_course_id >= len(course_ids) - 1:
		current_course_id = 0
	else:
		current_course_id += 1
			
	$TopicList.clear()
	var topics_list = topics[current_course_id]
	for topic in topics_list:
		if topic in topics_dict:
			$TopicList.add_item(topics_dict[topic])
	$CourseTitle.set_text(course_names[current_course_id])


func fresh_topic_list_left():
	if background_node != null:
		self.remove_child(background_node)
	var random_background_id = randi() % BACKGROUND_ID_UPPER_LIMIT
	var background_path = "res://assets/background/background_%s.tscn" % (str(random_background_id))
	print("Loading " + background_path)
	background_node = load(background_path).instance()
	self.add_child(background_node)
	self.move_child(background_node, 0) # re-order the scene to the end 
	
	# cylindral selection 
	if current_course_id <= 0:
		current_course_id = len(course_ids) - 1
	else:
		current_course_id -= 1
	
	$TopicList.clear()
	var topics_list = topics[current_course_id]
	for topic in topics_list:
		if topic in topics_dict:
			$TopicList.add_item(topics_dict[topic])
	$CourseTitle.set_text(course_names[current_course_id])
	
			
func submit_selection():
	var selections = $TopicList.get_selected_items()  # selection is length of 1
	if len(selections) ==  1:
		var topic_id = topics[current_course_id][selections[0]]
		print(topic_id)  # for log-in info 
		# change scene to quiz 
		var next_scene = load("res://quiz/QuizSelection/QuizSelectionUI.tscn").instance()
		next_scene.background_path = background_path
		next_scene.topic_id = topic_id
		var root = get_tree().get_root()
		root.remove_child(self)
		root.add_child(next_scene)


func _on_ReturnButton_button_down():
	var root = get_tree().get_root()
	var next_scnene = load("res://room/Room.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


