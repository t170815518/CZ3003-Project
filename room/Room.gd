extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Door.connect("body_entered", self, "_on_enter_door")


func _on_enter_door(collision_body):
	print("Go to world selection...")
	var root = get_tree().get_root()
	var next_scnene = preload("res://quiz/QuizSelection/QuizSelectionUI.tscn").instance()
	root.remove_child(self)
	root.add_child(next_scnene)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
