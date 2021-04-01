extends TextureButton

export(bool) var start_focused = false
onready var avatar5 = get_node(".")

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_on_avatar5_mouse_entered")
	connect("pressed",self,"_on_avatar5_Pressed")

func _on_avatar5_mouse_entered():
	grab_focus()
	
func _on_avatar5_Pressed():
	global.head_color = 5
