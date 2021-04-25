extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 6
var velocity = Vector2(0, 0)
var sprite_position = Vector2(0,0)
var username
var avatar_id


# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/Username.text = username
	$ClearMessage.connect("timeout", self, "_clear_message")
	if avatar_id == 1:
		var frames = preload("res://avatars/Avatar_1.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")
		# Called every frame. 'delta' is the elapsed time since the previous frame.
		#func _process(delta):
		#	pass
	elif avatar_id == 2:
		var frames = preload("res://avatars/Avatar_2.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")
	elif avatar_id ==3:
		var frames = preload("res://avatars/Avatar_3.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")
	elif avatar_id ==4:
		var frames = preload("res://avatars/Avatar_4.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")
	elif avatar_id ==5:
		var frames = preload("res://avatars/Avatar_5.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")



func set_message(s):
	$GUI/Message.text = s
	$ClearMessage.start()


func _clear_message():
	$GUI/Message.text = ""
	$ClearMessage.stop()
