extends Control



onready  var http=$HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
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
	get_tree().change_scene("res://room/Room.tscn")


func _on_cancel_btn_button_down():
	get_tree().change_scene("res://world/world.tscn")


func _on_skip_btn_button_down():
	get_tree().change_scene("res://room/Room.tscn")
