extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$Door.connect("body_entered", self, "_on_enter_door")
	$StartMultiQuizButton.connect("pressed", self, "_on_create_multiQuiz")
#	global.connect("invitationPopUp_changed", self, "on_invitationPopUp_changed")
#	print("id")
#	print(get_tree().get_network_unique_id())


func _on_enter_door(collision_body):
	print("Go to world selection...")
	var root = get_tree().get_root()
	var next_scnene = preload("res://quiz/CourseSelection/CourseSelection.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
	

func _on_Achivement_body_entered(body):
	print(body.get_name())
	print(body.get_position())
	if body.get_name()=='KinematicBody2D':
			var root = get_tree().get_root()
			var next_scnene = preload("res://room/Acheivement list.tscn").instance()
			root.remove_child(self)
			OS.delay_msec(50)  # for user response  
			root.add_child(next_scnene)

func _on_leaderboard_body_entered(body):
	print(body.get_name())
	if body.get_name()=='KinematicBody2D':
			var root = get_tree().get_root()
			var next_scnene = preload("res://leaderboard/leaderboard.tscn").instance()
			root.remove_child(self)
			OS.delay_msec(50)  # for user response  
			root.add_child(next_scnene)


func _on_world_body_shape_entered(body_id, body, body_shape, area_shape):
	print(body.get_name())
	if body.get_name()=='KinematicBody2D':
			var root = get_tree().get_root()
			var next_scnene = preload("res://world/world.tscn").instance()
			root.remove_child(self)
			OS.delay_msec(50)  # for user response  
			root.add_child(next_scnene)


func _on_create_multiQuiz():
	var data = {"method": "createRoom", "username": "Student1", "quizId": "60652e8becd0f6001569a181"}
	Websocket.send(JSON.print(data))


#func on_invitationPopUp_changed(value):
#	if global.invitationPopUp == true:
#		$AcceptInvitePop.refresh()
#		$AcceptInvitePop.popup_centered()
