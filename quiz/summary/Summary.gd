extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_win = true
var time = "0:00"
var total_questions = 10
var correct_answers = 10
const FACEBOOK_SHARE_URL = "https://www.facebook.com/sharer/sharer.php?kid_directed_site=0&sdk=joey&u=http%3A%2F%2F155.69.100.27%2F3003S22021_SSP4OwenAsyraaf%2Findex.php%2FMain_Page%23System_Architecture&display=popup&ref=plugin&src=share_button"
const TWITTER_SHARE_URL = "https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fpublish.twitter.com%2F&ref_src=twsrc%5Etfw&text=These%20are%20my%20achievements%3A&tw_p=tweetbutton&url=http%3A%2F%2F155.69.100.27%2F3003S22021_SSP4OwenAsyraaf%2Findex.php%2FMain_Page"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 
	

func refresh():
	# set background 
	# print("Loading " + background_path)
	# var background_node = load(background_path).instance()
	# self.add_child(background_node)
	# self.move_child(background_node, 0) # re-order the scene to the end 
	
	if is_win:
		$Title.set_text("Congratulations! You win the quiz!")
	else:
		$Title.set_text("Oops! Wish you good luck next time!")
	$TotalTime.set_text(str(time))
	$TotalAnswer.set_text(str(total_questions))
	$CorrectAnswer.set_text(str(correct_answers))
	$OKButton.connect("pressed", self, "_on_pressed_ok")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FBshare_button_down():
	OS.shell_open(FACEBOOK_SHARE_URL)



func _on_TWshare_button_down():
	OS.shell_open(TWITTER_SHARE_URL)
