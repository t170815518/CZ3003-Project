extends Control

onready  var http=$HTTPRequest
const FACEBOOK_SHARE_URL = "https://www.facebook.com/sharer/sharer.php?kid_directed_site=0&sdk=joey&u=http%3A%2F%2F155.69.100.27%2F3003S22021_SSP4OwenAsyraaf%2Findex.php%2FMain_Page%23System_Architecture&display=popup&ref=plugin&src=share_button"
const TWITTER_SHARE_URL = "https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fpublish.twitter.com%2F&ref_src=twsrc%5Etfw&text=These%20are%20my%20achievements%3A&tw_p=tweetbutton&url=http%3A%2F%2F155.69.100.27%2F3003S22021_SSP4OwenAsyraaf%2Findex.php%2FMain_Page"
onready var achievement_get_user_url = "https://ssad-api.herokuapp.com/api/v1/achievement/user/%s" %global.userID

# Called when the node enters the scene tree for the first time.
func _ready():
	#http.request('https://ssad-api.herokuapp.com/api/v1/user')
	$ItemList.add_item('loading...')
	http.request(achievement_get_user_url)
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$ItemList.remove_item(0)
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			#allachievement is an array of dictionary
			var allachievement = JSON.parse(body.get_string_from_utf8()).result["achievements"]
			for item in allachievement:
				$ItemList.add_item(item["achievement_desc"])

		else:
			print("http get achievement by user fails")

#	var json =JSON.parse(body.get_string_from_utf8())
#	for k in json.result.users.size():
#		if json.result.users[k].username==global.username:
#			print(json.result.users[k])
#			for n in json.result.users[k].achievement.size():
#				$ItemList.add_item(str(json.result.users[k].achievement[n]))
#	$ItemList.add_item("4.Level up to 40")
#	$ItemList.add_item("5.Level up to 60")
#	$ItemList.add_item("6.Level up to 80")

func _on_Button_button_down():
	#get_tree().change_scene("res://room/Room.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/Room.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)

func _on_FBshare_button_down():
	OS.shell_open(FACEBOOK_SHARE_URL)

func _on_TWshare_button_down():
	OS.shell_open(TWITTER_SHARE_URL)
