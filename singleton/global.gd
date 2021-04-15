extends Node

var username = "Student1"
var email = "Student123@gmail.com"
var userID = "605235a72ad01200153a3f03"
var password = ""
var avatar_id = 4
var previous_scene = ""
var selected_world = -1
var roomNumber=1
var worldNumber=6 
var roomCreated=false 
var roomAdmin=false
var invitationPopUp=0
var enterRoom=false
var excludedFriendsInList=[username]
var quizThemeId=""
var incorrectAnswer=false 
var playersVectors=[]
var Friends=[]
var is_multiplayer_mode = false 
var already_in_room_except_self = []
var already_in_room = []
var child_node_players = []
var current_question_id
var question_num
var is_quiz_loaded = false
