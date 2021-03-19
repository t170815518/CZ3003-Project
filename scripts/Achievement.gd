extends Panel

 onready var http=$HTTPRequest

func _ready():
	http.request("")
