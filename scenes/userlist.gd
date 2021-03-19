extends Panel

onready var http=$HTTPRequest
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	http.request("https://ssad-api.herokuapp.com/api/v1/user")
	
	


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json =JSON.parse(body.get_string_from_utf8())
	#print(json.result.users)
	var shift=0.0
	for player in json.result.users:
		var lbl= Label.new()
		lbl.align=Label.ALIGN_CENTER
		lbl.text=player.username
		
		print(player.username)
		var labelsize = lbl.get_combined_minimum_size().x
		var center =(self.rect_size.x-labelsize)/2;
		lbl.set_position(Vector2(center,20.0+shift))
		self.add_child(lbl)
		shift+=20.0
