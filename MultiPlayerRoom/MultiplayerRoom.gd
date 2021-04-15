extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$Door.connect("body_entered", self, "_on_enter_door")
	Websocket.connect("go_to_quiz", self, "_switch_to_quiz")
#	print("id")
#	print(get_tree().get_network_unique_id())'
	print(self.get_path())

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

#func _on_world_body_shape_entered(body_id, body, body_shape, area_shape):
#	print(body.get_name())
#	if body.get_name()=='KinematicBody2D':
#		var root = get_tree().get_root()
#		var next_scnene = preload("res://world/world.tscn").instance()
#		root.remove_child(self)
#		OS.delay_msec(50)  # for user response  
#		root.add_child(next_scnene)

func add_other_players(username, position, avatar_id):
	var another = load('res://MultiPlayerRoom/OtherPlayer.tscn').instance()
	add_child(another)
	another.init(username, position, avatar_id)
	global.child_node_players.append(another.get_index())

func set_other_players_position(username, index, position):
	var child = get_child(index)
	child.set_position(position)


func _switch_to_quiz():
	var root = get_tree().get_root()
	var next_scnene = load("res://quiz/MultiPlayerQuiz/QuizField.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
