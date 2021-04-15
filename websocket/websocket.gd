extends Node2D
# The URL we will connect to
#export var websocket_url = "ws://127.0.0.1:8080/"
#export var websocket_url = "ws://shielded-stream-65178.herokuapp.com/"
#xport var websocket_url = "ws://127.0.0.1:8080/"
export var websocket_url = "ws://shielded-stream-65178.herokuapp.com/"

# Our WebSocketClient instance
var _client = WebSocketClient.new()
var timer = 0
var timer_limit = 23 # in seconds
# signal for control & sync other class 
signal receive_data(data_str)
signal go_to_quiz
signal update_question(question_json)
signal update_leaderboard(info_json)
signal give_correct_answer
signal give_wrong_answer

func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")
	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)
func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
#	_client.get_peer(1).put_packet(JSON.print({"method":"connection","username":"ssad"}).to_utf8())
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	#_client.get_peer(1).put_packet(JSON.print({"method":"connection","username":"jeff wong2"}).to_utf8())
	#_client.get_peer(1).put_packet(JSON.print({"method":"test_pack"}).to_utf8())
func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var rawSinal=_client.get_peer(1).get_packet().get_string_from_utf8()
	var returnMsg= JSON.parse(rawSinal)
#	var already_in_room = []
#	var already_in_room_except_self = []
	var child_node_players = []

	print("Got data from server: ",returnMsg.result.method)
	if(returnMsg.result.method=="createRoom"):
		var temp = returnMsg.result
		global.roomNumber = temp.roomNumber
		global.worldNumber = temp.worldNumber
		global.roomCreated = temp.created
		global.roomAdmin = temp.roomAdmin
#		global.roomNumber=returnMsg.result.roomNumber
#		global.worldNumber=returnMsg.result.worldNumber
#		global.roomCreated=returnMsg.result.created 
#		global.roomAdmin=returnMsg.result.roomAdmin
		print("global.roomNumber: " + str(global.roomNumber))
		print("global.worldNumber:" + str(global.worldNumber))
	elif(returnMsg.result.method=="inviteFriends"):
#	&&returnMsg.result.username==global.username):
		var temp = returnMsg.result
		print(temp)
		global.invitationPopUp=true
		global.roomNumber=temp.roomNumber
		global.worldNumber=temp.worldNumber
		global.roomAdmin=temp.roomAdmin
		print("invite friends to")
		print(global.roomNumber)
		print(global.worldNumber)
		$'/root/Room/AcceptInvitePop'.popup_centered()
		global.already_in_room.append(returnMsg.result.username)
		print(global.already_in_room)
		
	elif(returnMsg.result.method=="enterRoom" and returnMsg.result.enter == true):
		var temp = returnMsg.result
		print(temp)
		global.enterRoom=temp.enter
		global.roomNumber=temp.roomNumber
		global.worldNumber=temp.worldNumber
		global.roomAdmin=temp.roomAdmin	
		global.already_in_room.append(returnMsg.result.username)
		print(global.already_in_room)
	elif(returnMsg.result.method=="usersEnterRoom"):
		var temp = returnMsg.result	
		for n in global.already_in_room.size():
			if global.already_in_room[n] != global.username and global.already_in_room.has(temp[n])==false:
				global.already_in_room_except_self.append(global.already_in_room[n])
		print(global.already_in_room_except_self)
#		for n in global.already_in_room_except_self.size():
#			next_scnene.add_other_players(global.already_in_room_except_self[n], Vector2(517, 200), 3)
#			print(global.child_node_players)
	elif(returnMsg.result.method=="get_question"):	
		var temp = returnMsg.result	
		global.quizThemeId=temp.quizLinkID
		emit_signal("update_question", returnMsg.result.question_id)
	elif(returnMsg.result.method=="Answer"):	
		var temp = returnMsg.result	
		global.incorrectAnswer=temp.correct	
	elif(returnMsg.result.method=="getQuiz"):
		global.question_num = returnMsg.result.question_num
		emit_signal("go_to_quiz")
	elif(returnMsg.result.method=="playersVectors"):
		var temp = returnMsg.result
		print(temp)
#		if global.already_in_room_except_self.has(returnMsg.result.ClientUserName):
#			for n in global.already_in_room_except_self.size():
#				if global.already_in_room_except_self[n] == temp.ClientUserName:
#					next_scnene.set_other_players_position(temp.ClientUserName,child_node_players[n], temp.playerMovement)
	elif (returnMsg.result.method=="info"):
		emit_signal("update_leaderboard", returnMsg.result.peers)
	elif returnMsg.result.method == "Answer":
		if returnMsg.result.correct == "true":
			emit_signal("give_correct_answer")
		else:
			emit_signal("give_wrong_answer")
			
func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()


# json: String 
func send(json):
	_client.get_peer(1).put_packet(JSON.print(json).to_utf8())  # to utf8 because param is PoolByteArray


func _reconnection():
	_client = WebSocketClient.new()
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)	
		
func _on_Button2_pressed():
	_client.get_peer(1).put_packet(JSON.print({"method":"getQuiz","quizID":"60652b78ecd0f6001569a163","username":"jeff wong","roomNumber":"1","worldNumber":"1"}).to_utf8())
	# for acceptInvitation
	#_client.get_peer(1).put_packet(JSON.print({"method":"acceptInvitation","username":"jeff wong","roomNumber":"1","worldNumber":"1"}).to_utf8())				

func _physics_process(delta):
	timer += delta
	
	if (timer > timer_limit):
		_client.get_peer(1).put_packet(JSON.print({"method":"ping"}).to_utf8())
		timer -= timer_limit
