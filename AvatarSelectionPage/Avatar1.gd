extends TextureButton

export(bool) var start_focused = false
onready var avatar1 = get_node(".")
onready var avatar1Pressed = false

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_on_avatar1_mouse_entered")
	connect("pressed",self,"_on_avatar1_Pressed")
	connect("focus_exited",self,"_on_Avatar1_focus_exited")

func _on_avatar1_mouse_entered():
	grab_focus()
	
func _on_avatar1_Pressed():
	global.head_color = 1
	avatar1Pressed = true
