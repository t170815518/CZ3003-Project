extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	# for testing purpose only 
	if global.is_WebSocket_OK == false:
		Websocket.init("Student1")
		global.is_WebSocket_OK = true
	$Door.connect("body_entered", self, "_on_enter_door")
	$StartMultiQuizButton.connect("pressed", self, "_on_create_multiQuiz")
	$JoinQuizButton.connect("pressed", self, "_on_join_quiz")
	$StartQuizButton.connect("pressed", self, "_on_start_quiz")
	$JoinRoomPopUp/Button.connect("pressed", self, "_on_submit_join")
	$JoinRoomPopUp/Cancel.connect("pressed", self, "_on_cancel_join")
	Websocket.connect("room_created", self, "_on_room_created")
	Websocket.connect("room_joined", self, "_on_room_joined")
	
	if global.is_admin:
		$StartQuizButton.visible = true
		_on_room_joined()
	else:
		$StartQuizButton.visible = false
	
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
	global.is_multiplayer_mode = true 
	var next_scene = load("res://quiz/CourseSelection/CourseSelection.tscn").instance()
	var root = get_tree().get_root()
	root.add_child(next_scene)	
	root.remove_child(self)


func _on_submit_join():
	var roomId = $JoinRoomPopUp/TextEdit.get_text()
	$JoinRoomPopUp.hide()
	var data = {"method": "joinRoom", "username": global.username, "roomId": roomId}
	Websocket.send(JSON.print(data))
	global.is_admin = false


func _on_join_quiz():
	$JoinRoomPopUp.popup_centered()


func _on_room_joined():
	if global.roomId:
		$RoomCreatedDialog/RoomId.text = global.roomId
		$RoomCreatedDialog.popup_centered()
		if global.is_admin:
			$StartQuizButton.visible = true


func _on_start_quiz():
	var data = {"method": "startQuiz", "roomId": global.roomId, "username": global.username}
	Websocket.send(JSON.print(data))


func _on_cancel_join():
	$JoinRoomPopUp.hide()


#func on_invitationPopUp_changed(value):
#	if global.invitationPopUp == true:
#		$AcceptInvitePop.refresh()
#		$AcceptInvitePop.popup_centered()
