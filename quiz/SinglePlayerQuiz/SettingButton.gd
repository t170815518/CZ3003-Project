extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_open_setting")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _open_setting():
	global.previous_scene = "res://quiz/SinglePlayerQuiz/QuizField.tscn"
	var root = get_tree().get_root()
	var next_scnene = preload("res://SettingPage/SettingPage.tscn").instance()
	root.remove_child(self)
	OS.delay_msec(50)  # for user response  
	root.add_child(next_scnene)
