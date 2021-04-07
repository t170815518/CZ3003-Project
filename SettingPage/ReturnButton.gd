extends Button

export(bool) var start_focused = false

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	connect("pressed",self,"_on_Button_Pressed")

func _on_Button_mouse_entered():
	grab_focus()
	
func _on_Button_Pressed():
	if (global.previous_scene != ""):
		get_tree().change_scene(global.previous_scene)
	else:
		get_tree().quit()
