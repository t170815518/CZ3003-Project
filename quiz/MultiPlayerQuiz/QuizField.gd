# combat interface for multi-player mode 
extends Control


# Declare member variables here. Examples:
var current_ques_id = -1  # starts from -1 to facilitate access questions by index from 0 
var questions_num = 0
var correct_answer = 0 
var questions = []
var quiz_id = "60652e8becd0f6001569a181"
var attempts = {}
var attempt_records = []
var latest_option = -2  # dummy value (not-dummy value: -1 to 4)

# HP values (dummy one)
export var player_hp = 10
var enemy_hp = 10

# assest
var background_path = "res://assets/background/background_4.tscn"
var player_sprite_id = 3
var rng = RandomNumberGenerator.new()

# user_id for test purpose 
var user_id = "605235a72ad01200153a3f03"

# for networking, default values are for testing if any 
var peers = []
var question_id  # the question id got from web-socket server 

var start_time
var end_time

const QUESTION_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/question"
const QUIZ_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/quiz"
const ATTEMPT_POST_URL = "https://ssad-api.herokuapp.com/api/v1/question/attempt"

signal complete_request
signal question_runs_out
signal win_quiz
signal lose
signal question_loaded


# Called when the node enters the scene tree for the first time.
func _ready():
	global.is_quiz_loaded = true
	rng.randomize()
	var enemy_sprite_id = rng.randi_range(1,5)
	global.is_multiplayer_mode = true
	# load sprites 
	var player_frames = load("res://avatars/Avatar_%s.tres" % str(player_sprite_id))
	var enemy_frames = load("res://avatars/Avatar_%s.tres" % str(enemy_sprite_id))
	$PlayerSprite.set_sprite_frames(player_frames)
	$EnemySprite.set_sprite_frames(enemy_frames)
	
	# OS.delay_msec(50)  # for user response  
	$PlayerSprite.set_animation("idle")
	$EnemySprite.set_animation("idle")
	self.connect("question_runs_out", self, "_on_question_runs_out")
	$HTTPRequestQuestion.connect("request_completed", self, "_on_question_request_completed")
	$Summary.get_node("OKButton").connect("pressed", self, "_switch_scene")
	$Timer.connect("timeout", self, "_on_time_out")
	$HTTPRequestPostAttempt.connect("request_completed", self, "_on_attempt_posted")
	self.connect("question_loaded", self, "update_question")
	# link signals: cannot too early otherwise AnswerField cannot load itemlist etc 
	get_node("AnswerField").connect("post_answer", self, "_on_post_answer")
	Websocket.connect("update_question", self, "_on_receive_question_id")
	Websocket.connect("update_leaderboard", self, "_update_leader_board")
	Websocket.connect("give_correct_answer", self, "_on_correct_answer")
	Websocket.connect("give_wrong_answer", self, "_on_wrong_answer")
	
	$LoadingPopUp.popup_centered()
	# request for quiz questions 
	$HTTPRequestQuestion.timeout = 100
	
	# set the hp_label 
	$EnemyHP.set_text(str(questions_num))
	enemy_hp = questions_num
	player_hp = enemy_hp / 2 + 1
	$PlayerHP.set_text(str(player_hp))
			

func _process(delta):
	$TimeLabel.set_text("Time:%s" % str(int($Timer.get_time_left())))


func _on_post_answer(option):
	# prepare for message to post in json format 
	var data_dict = {"method": "SelectedQuizAndUpdateSource", "username": global.username, "roomNumber": global.roomNumber, 
	"worldNumber": global.worldNumber, "givenAnswer": option, "questionID": global.current_question_id}
	Websocket.send(data_dict)
	latest_option = option


func _on_question_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			print(body.get_string_from_utf8())
			body = JSON.parse(body.get_string_from_utf8()).result
			questions.append(body)
			emit_signal("question_loaded")

			
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
			
func update_question():
	# display the question description and options 
	# TODO: support multiple types of questions 
	$RichTextLabel.text = ""
	# OS.delay_msec(50)  # for user response  
	# $PlayerSprite.set_animation("idle")
	# $EnemySprite.set_animation("idle")
	$AnswerField.clear_options()
	current_ques_id += 1
	var question = questions[current_ques_id]
	var options = question["option"]
	$RichTextLabel.add_text(question["question_desc"])
	for i in range(options.size()):
		$AnswerField.update_question(options[i]["answer_desc"])
		if options[i]["is_correct"] == true:
			$AnswerField.correct_answer_id = i
	start_time = OS.get_unix_time()
	$Timer.start()


func _on_finish_quiz(is_win):
	global.is_multiplayer_mode = false 
	end_time = OS.get_unix_time()
	var next_scene = $Summary
	next_scene.is_win = is_win
	next_scene.time = end_time - start_time
	next_scene.total_questions = global.question_num 
	next_scene.correct_answers = correct_answer
	$Summary.refresh()
	$Summary.popup_centered()
	_post_attempt()


# waits for post method completes 
func _switch_scene():
	global.is_multiplayer_mode = false 
	global.is_quiz_loaded = false 
	self.queue_free()
	var main_node = load("res://room/Room.tscn").instance()
	var root = get_tree().get_root()
	root.remove_child(self)
	root.add_child(main_node)


func _on_time_out():
	$AnswerField.emit_signal("post_answer", -1)


func _on_SettingButton_button_down():
	var root = get_tree().get_root()
	var next_scnene = preload("res://SettingPage/SettingPage.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_PlayerSprite_animation_finished():
	$PlayerSprite.play('idle')


func _on_EnemySprite_animation_finished():
	$EnemySprite.play('idle')


func _record_attempt(option):
	attempt_records.append([questions[current_ques_id], option])


func _post_attempt():
	# reformat attempt records 
	var attemps = []
	for i in range(len(attempt_records)):
		attemps.append({"question_id": attempt_records[i][0]["_id"], 
		"option": attempt_records[i][1]})
	# generate the query string 
	var query = {}
	query["quiz_id"] = quiz_id
	query["selection"] = attemps
	query["score"] = correct_answer
	query["overall"] = correct_answer * 10
	query["user_id"] = user_id
	# time format 
	var time = OS.get_datetime()
	var time_str = str(time["year"]) + "-" + str(time["month"]) + "-" + str(time["day"]) + " " + str(time["hour"]) + ":" + str(time["minute"]) + ":" + str(time["second"])
	query["created_date"] = time_str
	# convert the query data to json string 
	var json_str = JSON.print(query)
	# start request 
	var headers = ["Content-Type: application/json"]
	print("Posting the attempt")
	$HTTPRequestPostAttempt.request(ATTEMPT_POST_URL, headers, true, HTTPClient.METHOD_POST, json_str)

func _on_attempt_posted(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			print("Result posted")
		else:
			print("Error Code", response_code)
	else:
		print("Http connection fails")


# peers: json array 
func _update_leader_board(peers):
	# parse out peers' info from json 
	peers = []
	for i in range(peers.size()):
		peers.append(peers[i]["username"], peers[i]["score"])
	# sort the peers based on the scores 
	peers.sort_custom(MyCustomSorter, "sort_ascending")
	# format the leaderboard 
	$LeaderBoard.clear()
	for i in range(peers.size()):
		$LeaderBoard.add_item("%d%+10s%d" % [i, peers[i][0], peers[i][1]])


class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[1] > b[1]:
			return true
		return false

func _on_wrong_answer():
	# Assume not to update the question 
	$Timer.stop()
	player_hp -= 1
	_record_attempt(latest_option)
	$EnemySprite.play("attack")
	$PlayerHP.set_text(str(player_hp))
	$PlayerSprite.play("hit")
	if current_ques_id >= questions_num:
		_on_finish_quiz(false)


func _on_correct_answer():
	$Timer.stop()
	correct_answer += 1
	enemy_hp -= 1
	_record_attempt(latest_option)
	$PlayerSprite.play("attack")
	$EnemyHP.set_text(str(enemy_hp))
	$EnemySprite.play("hit")
	if current_ques_id >= questions_num:
		_on_finish_quiz(true)


func _on_receive_question_id(question_id):
	$HTTPRequestQuiz.request(QUESTION_GET_BASE_URL+"/"+question_id, [])
	global.current_question_id = question_id

