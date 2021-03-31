extends Control


# Declare member variables here. Examples:
var current_ques_id = -1  # to facilitate access questions by index from 0 
var questions_num = 0
var correct_answer = 0 
var questions = []
var quiz_id = "6038511a21ef180015b2176f"

# HP values 
export var player_hp = 5
var enemy_hp

# assest
var background_path = "res://assets/background/background_2.tscn"
var player_sprite_id = 1
var enemy_sprite_id = 2


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
	# add background 
	print("Loading " + background_path)
	var background_node = load(background_path).instance()
	self.add_child(background_node)
	self.move_child(background_node, 0) # re-order the scene to the end 
	
	# load sprites 
	var player_frames = load("res://avatars/Avatar_%s.tres" % str(player_sprite_id))
	var enemy_frames = load("res://avatars/Avatar_%s.tres" % str(enemy_sprite_id))
	$PlayerSprite.set_sprite_frames(player_frames)
	$EnemySprite.set_sprite_frames(enemy_frames)
	
	# link signals 
	get_node("AnswerField").connect("correct_answer", self, "_on_correct_answer")
	get_node("AnswerField").connect("wrong_answer", self, "_on_wrong_answer")	
	self.connect("question_runs_out", self, "_on_question_runs_out")
	$HTTPRequestQuiz.connect("request_completed", self, "_on_request_completed")
	$HTTPRequestQuestion.connect("request_completed", self, "_on_question_request_completed")
	$Summary.get_node("OKButton").connect("pressed", self, "_on_finish_quiz")
	
	$LoadingPopUp.popup_centered()
	# request for quiz questions 
	$HTTPRequestQuestion.timeout = 100
	$HTTPRequestQuiz.request(QUIZ_GET_BASE_URL, [])


# when the user gives the correct answer 
func _on_correct_answer():
	correct_answer += 1
	enemy_hp -= 1
	if enemy_hp > 0: 
		$PlayerSprite.set_animation("attack")
		$EnemyHP.set_text(str(enemy_hp))
		$EnemySprite.set_animation("hit")
		update_question()
	else:
		end_time = OS.get_unix_time()
		var next_scene = $Summary
		next_scene.is_win = true
		next_scene.time = end_time - start_time
		next_scene.total_questions = questions_num 
		next_scene.correct_answers = correct_answer
		$Summary.refresh()
		$Summary.popup_centered()


func _on_wrong_answer():
	# Assume not to update the question 
	player_hp -= 1
	if player_hp > 0: 
		$EnemySprite.set_animation("attack")
		$PlayerHP.set_text(str(player_hp))
		$PlayerSprite.set_animation("hit")
		update_question()
	else:
		end_time = OS.get_unix_time()
		var next_scene = $Summary
		next_scene.is_win = false
		next_scene.time = end_time - start_time
		next_scene.total_questions = questions_num 
		next_scene.correct_answers = correct_answer
		$Summary.refresh()
		$Summary.popup_centered()
	

func _on_request_completed(result, response_code, headers, body):
	# retrive information of questions 
	# TODO: support multi-size mcq
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			print(body.get_string_from_utf8())
			body = JSON.parse(body.get_string_from_utf8()).result["quizzes"][0]
			
			var question_ids = body["question_list"]
			$EnemyHP.set_text(str(len(question_ids)))
			enemy_hp = len(question_ids)
			player_hp = enemy_hp / 2
			$PlayerHP.set_text(str(player_hp))
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


func _on_question_runs_out():
	end_time = OS.get_unix_time()
	var next_scene = $Summary
	next_scene.is_win = true
	next_scene.time = end_time - start_time
	next_scene.total_questions = questions_num 
	next_scene.correct_answers = correct_answer
	$Summary.refresh()
	$Summary.popup_centered()

			
func update_question():
	# display the question description and options 
	# TODO: support multiple types of questions 
	$RichTextLabel.text = ""
	delete_children($AnswerField)
	
	OS.delay_msec(50)  # for user response  
	$PlayerSprite.set_animation("idle")
	$EnemySprite.set_animation("idle")
	
	current_ques_id += 1
	if current_ques_id >= questions_num:
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


func _on_finish_quiz():
	self.queue_free()
	var main_node = load("res://room/Room.tscn").instance()
	var root = get_tree().get_root()
	root.remove_child(self)
	root.add_child(main_node)