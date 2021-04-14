extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_world_1_button_down():
	global.selected_world = 1
	Websocket._send({"method":"createRoom", "worldNumber":1}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
	#get_tree().change_scene("res://room/PlayerInvites.tscn")
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()


func _on_world_2_button_down():
	global.selected_world = 2
	Websocket._send({"method":"createRoom", "worldNumber":2}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()

func _on_world_3_button_down():
	global.selected_world = 3
	Websocket._send({"method":"createRoom", "worldNumber":3}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()

func _on_world_4_button_down():
	global.selected_world = 4
	Websocket._send({"method":"createRoom", "worldNumber":4}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()

func _on_world_5_button_down():
	global.selected_world = 5
	Websocket._send({"method":"createRoom", "worldNumber":5}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()

func _on_world_6_button_down():
	global.selected_world = 6
	Websocket._send({"method":"createRoom", "worldNumber":6}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()

func _on_world_7_button_down():
	global.selected_world = 7
	Websocket._send({"method":"createRoom", "worldNumber":7}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()

func _on_world_8_button_down():
	global.selected_world = 8
	Websocket._send({"method":"createRoom", "worldNumber":8}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()

func _on_world_9_button_down():
	global.selected_world = 9
	Websocket._send({"method":"createRoom", "worldNumber":9}) #send world number to server
	OS.delay_msec(1150)
	if global.roomCreated:
		var root = get_tree().get_root()
		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
		root.remove_child(self)
		OS.delay_msec(50)  # for user response  
		root.add_child(next_scnene)
	else:
		$Popup.popup()

func _on_ReturnButton_button_down():
	var root = get_tree().get_root()
	var next_scnene = load("res://room/Room.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
