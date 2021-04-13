extends Node2D
# The URL we will connect to
#export var websocket_url = "ws://127.0.0.1:8080/"
export var websocket_url = "ws://shielded-stream-65178.herokuapp.com/"

# Our WebSocketClient instance
var _client = WebSocketClient.new()

var timer = 0
var timer_limit = 25 # in seconds


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
	_client.get_peer(1).put_packet(JSON.print({"method":"connection","username":"jeff wong2"}).to_utf8())
	#_client.get_peer(1).put_packet(JSON.print({"method":"test_pack"}).to_utf8())

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())
	

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
		
func _send():
	
	_client.get_peer(1).put_packet(JSON.print({"method":"inviteFriends","username":"jeff wong2","roomNumber":"1","worldNumber":"1","Friends":["jeff wong1", "jeff wong"]}).to_utf8())				


func _on_Button_button_down():
	_send()
	
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
