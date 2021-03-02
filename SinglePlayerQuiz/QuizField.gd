extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const QUESTION_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/question"
const QUESTION_ID_TEST = "6037f74f8debf30015505660"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnswerField").connect("correct_answer", self, "_on_correct_answer")
	get_node("AnswerField").connect("wrong_answer", self, "_on_wrong_answer")	
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	request_question(QUESTION_ID_TEST)

# when the user gives the correct answer 
func _on_correct_answer():
	var enemy 
	enemy = get_node("Enemy")
	enemy.hp -= 1
	if enemy.hp > 0: 
		get_node("Enemy/HpValue").set_text(str(enemy.hp))
	else:
		print("User wins the quiz!")  # player wins the quiz 
	# refresh the question 


func _on_wrong_answer():
	var player 
	player = get_node("Player")
	player.hp -= 1
	if player.hp > 0: 
		get_node("Player/HpValue").set_text(str(player.hp))
	else:
		print("User loses the quiz!")  # player loses the quiz 
	# refresh the question 
	

func request_question(question_id: String):
	var headers = []
	$HTTPRequest.request(QUESTION_GET_BASE_URL+"/"+question_id, headers)


func _on_request_completed(result, response_code, headers, body):
	# checks if the request is success, displays the question description and options
	# TODO: support multi-size mcq
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			print(body.get_string_from_utf8())
			body = JSON.parse(body.get_string_from_utf8()).result
			var question_desc = body["question_desc"]
			$RichTextLabel.add_text(question_desc)
			# display new options 
			var options 
			var option_desc
			options = $AnswerField.update_questions("mcq")
			for i in range(options.size()-1):
				print(i)
				option_desc = body["option"][i]["answer_desc"]
				print(option_desc)
				options[i].set_text(option_desc)
			
		else:
			print("Http error")
	else:
		print(result)
