extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnswerField").connect("correct_answer", self, "_on_correct_answer")
	get_node("AnswerField").connect("wrong_answer", self, "_on_wrong_answer")	

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
