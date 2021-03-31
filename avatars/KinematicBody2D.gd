extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 6
var velocity = Vector2(0, 0)
export var avatar_id = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	var frames
	if avatar_id == 1:
		frames = preload("res://avatars/Avatar_1.tres")  # default frame
	$AnimatedSprite.set_sprite_frames(frames)
	$AnimatedSprite.set_animation("idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	velocity = Vector2(0, 0)
	if Input.is_action_pressed('ui_right'):
		velocity.x = speed
	if Input.is_action_pressed('ui_left'):
		velocity.x = -speed
	if Input.is_action_pressed('ui_down'):
		velocity.y = speed
	if Input.is_action_pressed('ui_up'):
		velocity.y = -speed
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite.set_animation("run")
	else:
		$AnimatedSprite.set_animation("idle")
	move_and_collide(velocity)