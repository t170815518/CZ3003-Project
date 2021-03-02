extends Control


# Declare member variables here. Examples:
var current_ques_id = -1
var questions_num = -1
var questions = []
var quiz_id = "6038511a21ef180015b2176f"

const QUESTION_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/question"
const QUIZ_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/quiz"
const QUESTION_ID_TEST = "6037f74f8debf30015505660"

signal complete_request


# Called when the node enters the scene tree for the first time.
func _ready():
	# link signals 
	get_node("AnswerField").connect("correct_answer", self, "_on_correct_answer")
	get_node("AnswerField").connect("wrong_answer", self, "_on_wrong_answer")	
	$HTTPRequestQuiz.connect("request_completed", self, "_on_request_completed")
	$HTTPRequestQuestion.connect("request_completed", self, "_on_question_request_completed")
	# request for quiz questions 
	$HTTPRequestQuestion.timeout = 100
	$HTTPRequestQuiz.request(QUIZ_GET_BASE_URL, [])


# when the user gives the correct answer 
func _on_correct_answer():
	var enemy 
	enemy = get_node("Enemy")
	enemy.hp -= 1
	if enemy.hp > 0: 
		get_node("Enemy/HpValue").set_text(str(enemy.hp))
		update_question()
	else:
		print("User wins the quiz!")  # player wins the quiz 
	# refresh the question 


func _on_wrong_answer():
	# Assume not to update the question 
	var player 
	player = get_node("Player")
	player.hp -= 1
	if player.hp > 0: 
		get_node("Player/HpValue").set_text(str(player.hp))
	else:
		print("User loses the quiz!")  # player loses the quiz 
	# refresh the question 
	

func _on_request_completed(result, response_code, headers, body):
	# retrive information of questions 
	# TODO: support multi-size mcq
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			print(body.get_string_from_utf8())
			body = JSON.parse(body.get_string_from_utf8()).result["quizzes"][0]
			var question_ids = body["question_list"]
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
		print("User wins")
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
