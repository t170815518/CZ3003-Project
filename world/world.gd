extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	global.connect("worldNumber_changed", self, "on_worldNumber_changed")

func _on_ReturnButton_button_down():
	var root = get_tree().get_root()
	var next_scnene = load("res://room/Room.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
	
#func on_worldNumber_changed(value):
#	if global.roomCreated:
#		var root = get_tree().get_root()
#		var next_scnene = load("res://room/PlayerInvites.tscn").instance()
#		root.remove_child(self)
#		OS.delay_msec(50)  # for user response  
#		root.add_child(next_scnene)
#	else:
#		$Popup.popup()


func _on_world_3_pressed():
	global.selected_world = 3
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey":"3", "username": global.username, "avatarId": global.avatar_id})  #send world number to server


	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_2_pressed():
	global.selected_world = 2
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey":"2", "username": global.username, "avatarId": global.avatar_id}) #send world number to server


#	if global.roomCreated == true:
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
#	else:
#		$Popup.popup()

func _on_world_1_pressed():
	global.selected_world = 1
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey":"1", "username": global.username, "avatarId": global.avatar_id}) #send world number to server


#	if global.roomCreated == true:
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
#	else:
#		$Popup.popup()

func _on_world_4_pressed():
	global.selected_world = 4
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey": "4", "username": global.username, "avatarId": global.avatar_id}) #send world number to server


#	if global.roomCreated == true:
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
#	else:
#		$Popup.popup()

func _on_world_5_pressed():
	global.selected_world = 5
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey": "5", "username": global.username, "avatarId": global.avatar_id}) #send world number to server

#	if global.roomCreated == true:
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
#	else:
#		$Popup.popup()

func _on_world_6_pressed():
	global.selected_world = 6
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey": "6", "username": global.username, "avatarId": global.avatar_id}) #send world number to server


#	if global.roomCreated == true:
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
#	else:
#		$Popup.popup()

func _on_world_7_pressed():
	global.selected_world = 7
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey": "7", "username": global.username, "avatarId": global.avatar_id}) #send world number to server

#	if global.roomCreated == true:
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
#	else:
#		$Popup.popup()

func _on_world_8_pressed():
	global.selected_world = 8
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey": "8", "username": global.username, "avatarId": global.avatar_id}) #send world number to server

#	if global.roomCreated == true:
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
#	else:
#		$Popup.popup()


func _on_world_9_pressed():
	global.selected_world = 9
	Websocket.send({"method":"joinMultiPlayerRoom", "roomKey": "9", "username": global.username, "avatarId": global.avatar_id}) #send world number to server


#	if global.roomCreated == true:
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
#	else:
#		$Popup.popup()
