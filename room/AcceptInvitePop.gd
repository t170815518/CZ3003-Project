extends Control
var player_name = "player1"
var text = "Player %s invites you to a game" %player_name

func _ready():
	$Title.set_text(text)

func _on_Acceptbutton_button_down():
	var root = get_tree().get_root()
	var next_scnene = load("res://MultiPlayerRoom/MultiplayerRoom.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)



func _on_CancelButton_button_down():
	hide()
