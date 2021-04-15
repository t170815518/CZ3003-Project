extends Control

onready var USER_UPDATE_PUT_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/user/" + global.userID

func _ready():
	pass

func _on_NextButton_pressed():
	var sentData = {"head_color": global.avatar_id}
	var sentString = JSON.print(sentData)
	var headers = ["Content-Type: application/json"]
	print(sentData)
	$HTTPAvatar.request(USER_UPDATE_PUT_BASE_URL, headers, true, HTTPClient.METHOD_PUT, sentString)


func _on_HTTPAvatar_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			if global.previous_scene == "res://room/Room.tscn":
				get_tree().change_scene("res://SettingPage/SettingPage.tscn")
			else:
				get_tree().change_scene("res://WelcomePage/WelcomePage.tscn")
		else:
			print("HTTPrequest update user fails")
