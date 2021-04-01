extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var round_time = 10
var remain_time = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout", self, "_one_sec_past")
	$Label.set_text("Time:%s" % str(round_time))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
