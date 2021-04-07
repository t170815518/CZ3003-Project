extends TextureButton

export(bool) var start_focused = false
onready var avatar1_selectedPopup = get_node("/root/AvatarSelection/Avatar1Selected")
onready var avatar2_selectedPopup = get_node("/root/AvatarSelection/Avatar2Selected")
onready var avatar3_selectedPopup = get_node("/root/AvatarSelection/Avatar3Selected")
onready var avatar4_selectedPopup = get_node("/root/AvatarSelection/Avatar4Selected")
onready var avatar5_selectedPopup = get_node("/root/AvatarSelection/Avatar5Selected")

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_on_avatar2_mouse_entered")
	connect("pressed",self,"_on_avatar2_Pressed")

func _on_avatar2_mouse_entered():
	grab_focus()
	
func _on_avatar2_Pressed():
	if avatar1_selectedPopup.is_visible() == true:
		avatar1_selectedPopup.hide()
	if avatar3_selectedPopup.is_visible() == true:
		avatar3_selectedPopup.hide()
	if avatar4_selectedPopup.is_visible() == true:
		avatar4_selectedPopup.hide()
	if avatar5_selectedPopup.is_visible() == true:
		avatar5_selectedPopup.hide()
	avatar2_selectedPopup.popup()
	global.avatar_id = 2
