extends Button

export var reference_path = ""
export(bool) var start_focused = false

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_on_Button_mouse_entered")
	connect("pressed",self,"_on_Button_Pressed")

func _on_Button_mouse_entered():
	grab_focus()
	
func _on_Button_Pressed():
	if (reference_path != ""):
		global.previous_scene = "res://SettingPage/SettingPage.tscn"
		get_tree().change_scene(reference_path)
	else:
		get_tree().quit()
