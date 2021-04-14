extends Node2D
# The URL we will connect to
#export var websocket_url = "ws://127.0.0.1:8080/"
export var websocket_url = "ws://shielded-stream-65178.herokuapp.com/"

# Our WebSocketClient instance
var _client = WebSocketClient.new()

var timer = 0
var timer_limit = 23 # in seconds

# signal for control & sync other class 
signal receive_data(data_str)


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
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	#_client.get_peer(1).put_packet(JSON.print({"method":"connection","username":"jeff wong2"}).to_utf8())
	#_client.get_peer(1).put_packet(JSON.print({"method":"test_pack"}).to_utf8())

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var rawSinal=_client.get_peer(1).get_packet().get_string_from_utf8()
	emit_signal("receive_data", rawSinal)
	var returnMsg= JSON.parse(rawSinal)
	print("Got data from server: ",returnMsg.result.method)
	if(returnMsg.result.method=="createRoom"&& returnMsg.result.created==true):
		global.roomNumber=returnMsg.result.roomNumber
		global.worldNumber=returnMsg.result.worldNumber
		global.roomCreated=returnMsg.result.created 
		global.roomAdmin=returnMsg.result.roomAdmin
	elif(returnMsg.result.method=="inviteFriends"&&returnMsg.result==global.username):	
		global.invitationPopUp=true
		global.roomNumber=returnMsg.result.roomNumber
		global.worldNumber=returnMsg.result.worldNumber
		global.roomAdmin=returnMsg.result.roomAdmin
	elif(returnMsg.result.method=="enterRoom"&&returnMsg.result==global.username):
		global.enterRoom=returnMsg.result.enter
		global.roomNumber=returnMsg.result.roomNumber
		global.worldNumber=returnMsg.result.worldNumber
		global.roomAdmin=returnMsg.result.roomAdmin	
	elif(returnMsg.result.method=="usersEnterRoom"):	
		global.excludedFriendsInList=returnMsg.result.username
	elif(returnMsg.result.method=="get_question"):	
		global.quizThemeId=returnMsg.result.quizLinkID
	elif(returnMsg.result.method=="info"):	
		pass
	elif(returnMsg.result.method=="Answer"):	
		global.incorrectAnswer=returnMsg.result.correct	
	elif(returnMsg.result.method=="playersVectors"):	
		if(global.playersVectors.size()>=1&&global.playersVectors.size()<=5):
			var players={"ClientUserName":returnMsg.result.ClientUserName,
			"roomNumber":returnMsg.result.roomNumber,
			"worldNumber":returnMsg.result.worldNumber,
			"playerMovement":returnMsg.result.playerMovement}
			global.playersVectors.append(players)
			

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
		
		# REST OF THE CODE
