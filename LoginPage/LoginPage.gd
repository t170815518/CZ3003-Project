extends Control

# Fetch UI node
onready var login_page = get_node(".")

# Fetch input nodes in login page
onready var login_email_input = get_node("background/VBoxContainer/Email")
onready var login_password_input = get_node("background/VBoxContainer/Password")
onready var Invalid_popup = get_node("background/Invalid")

onready var next_button = get_node("background/VBoxContainer/NextButton")
const USER_LOGIN_POST_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/user/login"
const ALLUSER_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/user"


func _ready():
	$HTTPlogin.connect("request_completed", self, "_on_HTTPlogin_request_completed")
	$HTTPAllUser.connect("request_completed", self, "_on_HTTPAllUser_request_completed")



func _on_NextButton_pressed():
	if login_email_input.get_text() == "":
		Invalid_popup.popup()
	elif login_password_input.get_text() == "":
		Invalid_popup.popup()
	else:
		global.email = login_email_input.get_text()
		global.password = login_password_input.get_text()
		var loginField = {
				"email": global.email,
				"password": global.password,
				}
		var loginString = JSON.print(loginField)
		var headers = ["Content-Type: application/json"]
		$HTTPlogin.request(USER_LOGIN_POST_BASE_URL, headers, true, HTTPClient.METHOD_POST, loginString)


func _on_HTTPlogin_request_completed(result, response_code, _headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		#TODO: more if case for response code
		if response_code == 200:
			#alluser is an array of dictionary consisting of all users information
			print (global.email)
			yield(get_tree().create_timer(2.0), "timeout")
			$HTTPAllUser.request(ALLUSER_GET_BASE_URL)

		elif response_code == 400:
			login_email_input.clear()
			login_password_input.clear()
			Invalid_popup.popup()

		else:
			print("http login fails")

func _on_HTTPAllUser_request_completed(result, response_code, _headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:

		if response_code == 200:
			#alluser is an array of dictionary consisting of all users information
			var alluser = JSON.parse(body.get_string_from_utf8()).result["users"]
			for item in alluser:
				if item["email"] == global.email:
					var userInfo = item
					global.userID = userInfo["_id"]
					global.username = userInfo["username"]
					global.avatar_id = int(userInfo["head_color"])
					print (global.userID)
					print (global.email)
					print (global.avatar_id)
					global.is_WebSocket_OK = true
					Websocket.init(global.username)
					var root = get_tree().get_root()
					var next_scnene = load("res://room/Room.tscn").instance()
					root.remove_child(self)
					OS.delay_msec(50)  # for user response  
					root.add_child(next_scnene)
		else:
			print("http get all user fails")


func _on_Password_text_changed(new_text):
	login_password_input.set_secret(true)
