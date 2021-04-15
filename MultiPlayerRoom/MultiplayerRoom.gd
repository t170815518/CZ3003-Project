extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$Door.connect("body_entered", self, "_on_enter_door")
	Websocket.connect("receive_data", self, "_on_data_received")
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
		var next_scnene = load("res://quiz/CourseSelection/CourseSelection.tscn").instance()
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


func _on_data_received(data_str):
	var json = JSON.parse(data_str).result
	if json["method"] == "getQuiz":
		var root = get_tree().get_root()
		var next_scnene = load("res://quiz/MultiPlayerQuiz/QuizField.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
