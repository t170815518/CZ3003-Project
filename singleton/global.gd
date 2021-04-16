extends Node

var username = "Student1"
var email = "Student123@gmail.com"
var userID = "605235a72ad01200153a3f03"
var password = ""
var avatar_id = 4
var previous_scene = ""
var selected_world = -1
var roomNumber=1
var worldNumber=6 setget setworldNumber
var roomCreated=false 
var roomAdmin=false
var invitationPopUp=false setget setinvitationPopUP
var enterRoom=false setget setenterRoom
var excludedFriendsInList=[username]
var quizThemeId=""
var incorrectAnswer=false 
var playersVectors=[]


var is_multiplayer_mode = false 
var already_in_room_except_self = []
var already_in_room = []
var child_node_players = []

# Websocket_2 attribute 
var roomId
var sync_questionNum = 0 setget set_sync_questionNum
var is_quiz_loaded = false
var is_admin = false 
var is_WebSocket_OK = false 

signal invitationPopUp_changed
signal worldNumber_changed
signal enterRoom_changed
signal update_question


func setinvitationPopUP(value):
	emit_signal("invitationPopUp_changed", invitationPopUp)

func setworldNumber(value):
	emit_signal("worldNumber_changed", worldNumber)

func setenterRoom(value):
	emit_signal("enterRoom_changed", enterRoom)

func set_sync_questionNum(value):
	emit_signal("update_question")
