extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$Door.connect("body_entered", self, "_on_enter_door")
	print("id")
	print(get_tree().get_network_unique_id())


func _on_enter_door(collision_body):
	print("Go to world selection...")
	var root = get_tree().get_root()
	var next_scnene = preload("res://quiz/CourseSelection/CourseSelection.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)

func _on_world_body_shape_entered(body_id, body, body_shape, area_shape):
	print(body.get_name())
	if body.get_name()=='KinematicBody2D':
			var root = get_tree().get_root()
			var next_scnene = preload("res://world/world.tscn").instance()
			root.remove_child(self)
			OS.delay_msec(50)  # for user response  
			root.add_child(next_scnene)





