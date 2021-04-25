extends Node2D
# The URL we will connect to

export var websocket_url = "ws://localhost:8025/websockets/multi_quiz/"

# Our WebSocketClient instance
var _client = WebSocketClient.new()
var timer = 0
var timer_limit = 23 # in seconds
# signal for control & sync other class 
signal receive_data(data_str)
signal update_question(json)
signal room_created(roomId)
signal room_joined
signal user_joined_room(json)
signal user_move(json)
signal user_chat(json)


func _ready():
	pass 

func init(username):
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")
	websocket_url += username
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
	var another = load('res://MultiPlayerRoom/OtherPlayer.tscn').instance()
	print("Got data from server: ",returnMsg.result.method)
	if returnMsg.result.method == "roomJoined":
		global.roomId = returnMsg.result["roomId"]
		if global.is_admin:
			var next_scene = load("res://room/Room.tscn").instance()
			var root = get_tree().get_root()
			root.add_child(next_scene)
		else:
			emit_signal("room_joined")
	elif returnMsg.result.method == "updateQuestion":
		if global.is_quiz_loaded:
			emit_signal("update_question", returnMsg.result) 
		else: 
			var next_scene = load("res://quiz/MultiPlayerQuiz/QuizField.tscn").instance()
			next_scene.quiz_id = returnMsg.result.quizId
			next_scene.jsonBuffer = returnMsg.result
			var root = get_tree().get_root()
			global.roomId = returnMsg.result.roomId
			root.add_child(next_scene)	
	elif returnMsg.result.method == "joinMultiRoom":
		if returnMsg.result.username != global.username:
			emit_signal("user_joined_room", returnMsg.result)
	elif returnMsg.result.method == "move":
		if returnMsg.result.username != global.username:
			emit_signal("user_move", returnMsg.result)
	elif returnMsg.result.method == "chat":
		emit_signal("user_chat", returnMsg.result)
			
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
