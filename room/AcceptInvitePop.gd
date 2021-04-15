extends Control
var text = "A player has invited you to a game"

func _ready():
#	global.connect("enterRoom_changed", self, "on_enterRoom_changed")
	$Title.set_text(text)

func _on_Acceptbutton_button_down():
	var acceptInfo = {
		"method": "acceptInvitation",
		"username": global.username,
		"roomNumber": global.roomNumber,
		"worldNumber": global.worldNumber,
		"avatarID": global.avatar_id
	}
	Websocket.send(acceptInfo)
	
#func on_enterRoom_changed(value):
#	if global.enterRoom == true:
#		global.invitationPopUp = false
#		var root = get_tree().get_root()
#		var next_scnene = load("res://MultiPlayerRoom/MultiplayerRoom.tscn").instance()
#		root.remove_child(self)
#		OS.delay_msec(50)  # for user response  
#		root.add_child(next_scnene)
#	else:
#		global.excludedFriendsInList.erase(global.username)
#		global.invitationPopUp = false
#		hide()


func _on_CancelButton_button_down():
	global.excludedFriendsInList.erase(global.username)
	global.invitationPopUp = false
	hide()

#func _physics_process(delta):
#	if global.enterRoom == true:
#		var root = get_tree().get_root()
#		var next_scnene = preload("res://MultiPlayerRoom/MultiplayerRoom.tscn").instance()
#		root.remove_child(self)
#		OS.delay_msec(50)  # for user response  
#		root.add_child(next_scnene)
