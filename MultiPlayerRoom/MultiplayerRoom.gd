extends Node2D


var user_node_mapping = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	$Door.connect("body_entered", self, "_on_enter_door")
	Websocket.connect("user_joined_room", self, "_on_user_joined")
	Websocket.connect("user_move", self, "_on_user_move")
	Websocket.connect("user_chat", self, "_on_user_chat")
	$ChatSubmissionButton.connect("pressed", self, "_on_submit_chat")
#	print("id")
#	print(get_tree().get_network_unique_id())'
	print(self.get_path())

#	var players={"ClientUserName":returnMsg.result.ClientUserName,
#			"roomNumber":returnMsg.result.roomNumber,
#			"worldNumber":returnMsg.result.worldNumber,
#			"playerMovement":returnMsg.result.playerMovement}
#			global.playersVectors.append(players)

#	if global.playersVectors.empty() != true:
#		for numPlayer in global.playersVectors.size():
#			if global.playersVectors[numPlayer].ClientUserName != global.username and global.playersVectors[numPlayer].roomNumber == global.roomNumber and global.playersVectors[numPlayer].worldNumber == global.worldNumber:
#				var another = load('res://MultiPlayerRoom/Player.tscn').instance()
#				$'../MultiplayerRoom'.add_child(another)
#				another.init(global.playersVectors[numPlayer].ClientUserName, Vector2(517, 306), 2)
#



func _on_enter_door(collision_body):
	# only admin can choose
	if global.roomAdmin:
		print("Go to world selection...")
		var root = get_tree().get_root()
		global.is_multiplayer_mode = true 
		var next_scnene = preload("res://quiz/CourseSelection/CourseSelection.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		pass 

func _on_world_body_shape_entered(body_id, body, body_shape, area_shape):
	print(body.get_name())
	if body.get_name()=='KinematicBody2D':
		var root = get_tree().get_root()
		var next_scnene = preload("res://world/world.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)


func _on_user_joined(json):
	var newAvatar = load("res://avatars/OtherPlayerAvatar.tscn").instance()
	newAvatar.username = json.username
	newAvatar.avtar_id = json.avatarId
	var root = get_tree().get_root()
	user_node_mapping[json.username] = newAvatar
	root.add_child(newAvatar)


func _on_user_move(json):
	var avatarToMove = user_node_mapping[json.username]
	avatarToMove.set_position(Vector2((int(json.up)), int(json.right)))


func _on_submit_chat():
	var chat = $ChatInput.text
	if chat != "" and chat != "[Type chat here...]":
		var chat_info = {"method": "chat", "roomKey": str(global.selected_world), "message": chat, "username": global.username}
		Websocket.send(chat_info)
		$ChatInput.text = "[Type chat here...]"  # clear the message box 


func _on_user_chat(json):
	if json.username == global.username:
		$Avatar/KinematicBody2D.set_message(json.content)
	else:
		var avatarToChat = user_node_mapping[json.usernam]
		avatarToChat.set_message(json.content)
