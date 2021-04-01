extends Control

onready  var http=$HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	http.request('https://ssad-api.herokuapp.com/api/v1/user')
	$ItemList.add_item('loading...')
	





func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$ItemList.remove_item(0)
	
	var json =JSON.parse(body.get_string_from_utf8())
	for k in json.result.users.size():
		if json.result.users[k].username=='Student1':
			print(json.result.users[k])
			for n in json.result.users[k].achievement.size():
				$ItemList.add_item(str(json.result.users[k].achievement[n]))
	$ItemList.add_item("4.Level up to 40")
	$ItemList.add_item("5.Level up to 60")
	$ItemList.add_item("6.Level up to 80")



func _on_Button_button_down():
	#get_tree().change_scene("res://room/Room.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/Room.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
