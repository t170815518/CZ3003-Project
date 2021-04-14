extends Node


export var socket_url = ""
var client = WebSocketClient.new()



func _ready():
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_error")
	client.connect("connection_established", self, "_on_connection_established")
	client.connect("data_received", self, "_on_data_received")
	
	var error = client.connect_to_url(socket_url)
	if error != OK:
		print("Unable to connect")


func _process(delta):
	client.poll()


func _on_data_received():
	var data = JSON.parse(client.get_peer(1).get_packet().get_string_from_utf8()).result
	print("Receives data: ", data)


func _on_connection_closed(was_clean = false):
	pass 


func _send():
	client.get_peer(1).put_packet(JSON.print({"test":"Test"}))


func _on_connection_established(proto = ""):
	pass 


func post_create_room_request():
	pass 
