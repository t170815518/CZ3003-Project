extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(time_used, correct_num, total_num):
	$CorrectAnswerNum.set_text(str(correct_num) + "/" + str(total_num))
	$TimeUsedLabel.set_text(time_used + "s")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
