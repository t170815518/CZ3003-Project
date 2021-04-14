extends Control

onready  var http=$HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	http.request('http://ssad-api.herokuapp.com/api/v1/leaderboard')
	$ItemList.add_item('loading...')


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$ItemList.remove_item(0)
#	$ItemList.add_item("Dave - 10")
#	$ItemList.add_item("James - 5")
#	$ItemList.add_item("Cherry - 2")
#	$ItemList.add_item("User3 - 2")
	var json =JSON.parse(body.get_string_from_utf8())
	for k in json.result.users.size():
			print(json.result.users[k])
			if json.result.users[k].username!='admin (Do not edit/delete this account)':
				$ItemList.add_item(str(json.result.users[k].username)+" - "+str(json.result.users[k].score))
	


func _on_Button_button_down():
	#get_tree().change_scene("res://room/Room.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/Room.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)

	


