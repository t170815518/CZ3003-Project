extends Control

func _ready():
	pass # Replace with function body.


func _on_LowBGM_pressed():
	BackgroundMusic.set_volume_db(-20)


func _on_MediumBGM_pressed():
	BackgroundMusic.set_volume_db(-10)


func _on_HighBGM_pressed():
	BackgroundMusic.set_volume_db(0)
