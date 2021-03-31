extends Control

func _ready():
	pass # Replace with function body.


func _on_LowBGM_pressed():
	BackgroundMusic.set_volume_db(-5)


func _on_MediumBGM_pressed():
	BackgroundMusic.set_volume_db(0)


func _on_HighBGM_pressed():
	BackgroundMusic.set_volume_db(10)
