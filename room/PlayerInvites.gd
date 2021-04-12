extends Control

onready  var http=$HTTPRequest
onready var background_path = "res://assets/background/background_%s.tscn" % (str(global.selected_world+4))
onready var background_node = null
# Called when the node enters the scene tree for the first time.
func _ready():
	background_node = load(background_path).instance()
	self.add_child(background_node)
	self.move_child(background_node, 0) # re-order the scene to the end 
	http.request('https://ssad-api.herokuapp.com/api/v1/user')
	$ItemList.add_item('loading...')
	

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$ItemList.remove_item(0)
	var json =JSON.parse(body.get_string_from_utf8())
	print(json.result.users[0])
	#json.result.users.size()
	for n in json.result.users.size():
		if json.result.users[n].username !='admin (Do not edit/delete this account)':
			$ItemList.add_item(str(json.result.users[n].username))
	


func _on_invite_btn_pressed():
	var playerSelected = $ItemList.get_selected_items() #get selected username
	#get_tree().change_scene("res://room/Room.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://MultiPlayerRoom/MultiplayerRoom.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_cancel_btn_button_down():
	#get_tree().change_scene("res://world/world.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://world/world.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
