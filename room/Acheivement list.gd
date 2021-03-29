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
	for n in json.result.users[0].achievement.size():
		$ItemList.add_item(str(json.result.users[0].achievement[n]))
	
