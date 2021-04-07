extends Control

# Fetch UI node
onready var register_account_page = get_node(".")

# Fetch input nodes in register page
onready var register_username_input = get_node("background/VBoxContainer/Username")
onready var register_password_input = get_node("background/VBoxContainer/Password")
onready var register_confirm_password_input = get_node("background/VBoxContainer/ConfirmPassword")
onready var register_email_input = get_node("background/VBoxContainer/Email")
onready var username_error_popup = get_node("background/UsernameError")
onready var password_invalid_popup = get_node("background/PasswordInvalidError")
onready var password_Unmatch_popup = get_node("background/PasswordMatchError")
onready var email_invalid_popup = get_node("background/EmailInvalidError")
onready var already_registered_popup = get_node("background/AlreadyRegistered")
onready var next_button = get_node("background/VBoxContainer/NextButton")

const USER_REGISTER_POST_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/user/register"
const ALLUSER_GET_BASE_URL = "https://ssad-api.herokuapp.com/api/v1/user"

func _ready():
	$HTTPAllUser.connect("request_completed", self, "_on_HTTPAllUser_request_completed")

#TODO: check if account is already in the database
func _on_NextButton_pressed():
	var username = register_username_input.get_text()
	var password = register_password_input.get_text()
	var confirm_password = register_confirm_password_input.get_text()
	var email = register_email_input.get_text()
	var PWresult = _check_password(password)
	var Email_result = _check_email(email)

	if username == "":
		username_error_popup.popup()
	elif not PWresult:
		password_invalid_popup.popup()
	elif password != confirm_password:
		password_Unmatch_popup.popup()
	elif not Email_result:
		email_invalid_popup.popup()
	else:
		register_user_in_database(username, password, email)

func register_user_in_database(username, password, email):		
	global.username = username
	global.email = email
	var userInfoField = {
		"username": username,
		"password": password,
		"email": email,
		"role": "Student"
		}
	var userString = JSON.print(userInfoField)
	var headers = ["Content-Type: application/json"]
	$HTTPRequestRegister.request(USER_REGISTER_POST_BASE_URL, headers, true, HTTPClient.METHOD_POST, userString)

# A function to check if input password fullfil the requirement
func _check_password(password):
	var regex = RegEx.new()
	regex.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!#%*?&]{6,20}$")
	var result = regex.search(password)
	return result
	
func _check_email(email):
	var regex = RegEx.new()
	regex.compile("^[\\w-]+(?:\\.[\\w-]+)*@(?:[\\w-]+\\.)+[a-zA-Z]{2,7}$")
	var result = regex.search(email)
	return result


func _on_register_request_completed(result, response_code, _headers, _body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			yield(get_tree().create_timer(2.0), "timeout")
			$HTTPAllUser.request(ALLUSER_GET_BASE_URL)

		elif response_code == 500:
			already_registered_popup.popup()
			register_username_input.clear()
			register_password_input.clear()
			register_confirm_password_input.clear()
			register_email_input.clear()

		else:
			print("http post fails")


func _on_HTTPAllUser_request_completed(result, response_code, _headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		#TODO: more if case for response code
		if response_code == 200:
			#alluser is an array of dictionary consisting of all users information
			var alluser = JSON.parse(body.get_string_from_utf8()).result["users"]
			for item in alluser:
				if item["username"] == global.username and item["email"] == global.email:
					var userInfo = item
					global.userID = userInfo["_id"]
					print (global.username)
					print (global.userID)
					print (global.email)
					get_tree().change_scene("res://AvatarSelectionPage/AvatarSelection.tscn")
		else:
			print("http get all user fails")


func _on_Password_text_changed(new_text):
	register_password_input.set_secret(true)


func _on_ConfirmPassword_text_changed(new_text):
	register_confirm_password_input.set_secret(true)
