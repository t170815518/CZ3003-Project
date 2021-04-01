extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_world_1_button_down():
	#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_2_button_down():
		#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_3_button_down():
			#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_4_button_down():
		#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_5_button_down():
		#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_6_button_down():
			#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_7_button_down():
			#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_8_button_down():
			#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)


func _on_world_9_button_down():
		#get_tree().change_scene("res://room/PlayerInvites.tscn")
	var root = get_tree().get_root()
	var next_scnene = load("res://room/PlayerInvites.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
