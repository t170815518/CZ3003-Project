extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Door.connect("body_entered", self, "_on_enter_door")
	$Achivement.connect("body_entered", self, "_on_Achivement_body_entered")


func _on_enter_door(collision_body):
	print("Go to world selection...")
	var root = get_tree().get_root()
	var next_scnene = preload("res://quiz/CourseSelection/CourseSelection.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
	

func _on_Achivement_body_entered(body):
	print(body.get_name())
	if body.get_name()=='KinematicBody2D':
			var root = get_tree().get_root()
			var next_scnene = preload("res://room/Acheivement list.tscn").instance()
			root.remove_child(self)
			OS.delay_msec(50)  # for user response  
			root.add_child(next_scnene)


func _on_outdoor_body_entered(body):
	print(body.get_name())
	if body.get_name()=='KinematicBody2D':
			var root = get_tree().get_root()
			var next_scnene = preload("res://world/world.tscn").instance()
			root.remove_child(self)
			OS.delay_msec(50)  # for user response  
			root.add_child(next_scnene)


func _on_leaderboard_body_entered(body):
	print(body.get_name())
	if body.get_name()=='KinematicBody2D':
			var root = get_tree().get_root()
			var next_scnene = preload("res://leaderboard/leaderboard.tscn").instance()
			root.remove_child(self)
			OS.delay_msec(50)  # for user response  
			root.add_child(next_scnene)
