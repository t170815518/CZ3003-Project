extends Node

var username = "Student1"
var email = "Student123@gmail.com"
var userID = "605235a72ad01200153a3f03"
var password = ""
var avatar_id = 4
var previous_scene = ""
var selected_world = -1
var roomNumber=-1
var worldNumber=-1
var roomCreated=false 
var roomAdmin=false
var invitationPopUp=false
var enterRoom=false
var excludedFriendsInList=""
var quizThemeId=""
var incorrectAnswer=false 
var playersVectors=[]

var is_multiplayer_mode = false 

# global nodes 
var websocket

func _ready():
	websocket = load("res://websocket/websocket.tscn").instance()
