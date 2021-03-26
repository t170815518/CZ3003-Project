extends Control


# Declare member variables here. Examples:
var current_ques_id = -1  # to facilitate access questions by index from 0 
var questions_num = -1
var correct_answer = 0 
var questions = []
var quiz_id = "6038511a21ef180015b2176f"

var start_time
var end_time

const QUESTION_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/question"
const QUIZ_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/quiz"


signal complete_request
signal question_runs_out
signal win_quiz
signal lose


# Called when the node enters the scene tree for the first time.
func _ready():
	# link signals 
	get_node("AnswerField").connect("correct_answer", self, "_on_correct_answer")
	get_node("AnswerField").connect("wrong_answer", self, "_on_wrong_answer")	
	$HTTPRequestQuiz.connect("request_completed", self, "_on_request_completed")
	$HTTPRequestQuestion.connect("request_completed", self, "_on_question_request_completed")
	
	$LoadingPopUp.popup_centered()
	# request for quiz questions 
	$HTTPRequestQuestion.timeout = 100
	$HTTPRequestQuiz.request(QUIZ_GET_BASE_URL, [])


# when the user gives the correct answer 
func _on_correct_answer():
	var enemy 
	enemy = get_node("Enemy")
	enemy.hp -= 1
	correct_answer += 1
	if enemy.hp > 0: 
		get_node("Enemy/HpValue").set_text(str(enemy.hp))
		update_question()
	else:
		end_time = OS.get_unix_time()
		var next_scene = preload("res://quiz/summary/Summary.tscn").instance()
		next_scene.is_win = true
		next_scene.time = end_time - start_time
		next_scene.total_questions = questions_num + 1 # because it starts from -1
		next_scene.correct_answers = correct_answer
		var root = get_tree().get_root()
		root.remove_child(self)
		root.add_child(next_scene)


func _on_wrong_answer():
	# Assume not to update the question 
	var player 
	player = get_node("Player")
	player.hp -= 1
	if player.hp > 0: 
		get_node("Player/HpValue").set_text(str(player.hp))
	else:
		end_time = OS.get_unix_time()
		var next_scene = preload("res://quiz/summary/Summary.tscn").instance()
		next_scene.is_win = true
		next_scene.time = end_time - start_time
		next_scene.total_questions = questions_num + 1  # because it starts from -1
		next_scene.correct_answers = correct_answer
		var root = get_tree().get_root()
		root.remove_child(self)
		root.add_child(next_scene)
	

func _on_request_completed(result, response_code, headers, body):
	# retrive information of questions 
	# TODO: support multi-size mcq
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			print(body.get_string_from_utf8())
			body = JSON.parse(body.get_string_from_utf8()).result["quizzes"][0]
			
			var question_ids = body["question_list"]
			$Enemy.hp = len(question_ids)
			print(question_ids)
			for question_id in question_ids:
				questions_num += 1
				var status = $HTTPRequestQuestion.request(QUESTION_GET_BASE_URL+"/"+question_id, [])
				# when the server is busy
				while status != 0:
					OS.delay_msec(1000)
					status = $HTTPRequestQuestion.request(QUESTION_GET_BASE_URL+"/"+question_id, [])
				if status == 0:
					yield(self, "complete_request")
				print(question_id)
			remove_child($LoadingPopUp)
			update_question()


func _on_question_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			print(body.get_string_from_utf8())
			body = JSON.parse(body.get_string_from_utf8()).result
			questions.append(body)
			emit_signal("complete_request")

			
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
			
			
func update_question():
	# display the question description and options 
	# TODO: support multiple types of questions 
	$RichTextLabel.text = ""
	delete_children($AnswerField)
	
	current_ques_id += 1
	if current_ques_id > questions_num:
		emit_signal("question_runs_out")
	else: 
		var question = questions[current_ques_id]
		var options = question["option"]
		$RichTextLabel.add_text(question["question_desc"])
		# display buttons for mcq 
		var buttons = $AnswerField.update_questions(options.size())
		for i in range(options.size()):
			buttons[i].set_text(options[i]["answer_desc"])
			if options[i]["is_correct"] == true:
				buttons[i].connect("pressed", self, "_on_correct_answer")
			else:
				buttons[i].connect("pressed", self, "_on_wrong_answer")
	start_time = OS.get_unix_time()
