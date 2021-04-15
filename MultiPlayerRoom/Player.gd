extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 6
var velocity = Vector2(0, 0)
var sprite_position = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/Username.text = global.username
	if global.avatar_id == 1:
		var frames = preload("res://avatars/Avatar_1.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")
		# Called every frame. 'delta' is the elapsed time since the previous frame.
		#func _process(delta):
		#	pass
	elif global.avatar_id == 2:
		var frames = preload("res://avatars/Avatar_2.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")
	elif global.avatar_id ==3:
		var frames = preload("res://avatars/Avatar_3.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")
	elif global.avatar_id ==4:
		var frames = preload("res://avatars/Avatar_4.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")
	elif global.avatar_id ==5:
		var frames = preload("res://avatars/Avatar_5.tres")  # default frame
		$AnimatedSprite.set_sprite_frames(frames)
		$AnimatedSprite.set_animation("idle")


func _physics_process(delta):
	velocity = Vector2(0, 0)
	if Input.is_action_pressed('ui_right'):
		velocity.x = speed
		sprite_position = get_position()
		var userInfo = {
		"method": "playerMovement",
		"username": global.username,
		"roomNumber": 1,
		"worldNumber": 1,
		"playerMovement": sprite_position
		}
		print (userInfo)
		Websocket._send(userInfo)
		#didnt work
	if Input.is_action_pressed('ui_left'):
		velocity.x = -speed
		sprite_position = get_position()
		var userInfo = {
		"method": "playerMovement",
		"username": global.username,
		"roomNumber": 1,
		"worldNumber": 1,
		"playerMovement": sprite_position
		}
		print (userInfo)
		Websocket._send(userInfo)
	if Input.is_action_pressed('ui_down'):
		velocity.y = speed
		sprite_position = get_position()
		var userInfo = {
		"method": "playerMovement",
		"username": global.username,
		"roomNumber": 1,
		"worldNumber": 1,
		"playerMovement": sprite_position
		}
		print (userInfo)
		Websocket._send(userInfo)
	if Input.is_action_pressed('ui_up'):
		velocity.y = -speed
		sprite_position = get_position()
		var userInfo = {
		"method": "playerMovement",
		"username": global.username,
		"roomNumber": 1,
		"worldNumber": 1,
		"playerMovement": sprite_position
		}
		print (userInfo)
		Websocket._send(userInfo)
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite.set_animation("run")
	else:
		$AnimatedSprite.set_animation("idle")
	move_and_collide(velocity)


#func init(username, start_position, avatarID):
#	$GUI/Username.text = username
#	global_position = start_position
#	if avatarID == 1:
#		var frames = preload("res://avatars/Avatar_1.tres")  # default frame
#		$AnimatedSprite.set_sprite_frames(frames)
#		$AnimatedSprite.set_animation("idle")
#		# Called every frame. 'delta' is the elapsed time since the previous frame.
#		#func _process(delta):
#		#	pass
#	elif avatarID == 2:
#		var frames = preload("res://avatars/Avatar_2.tres")  # default frame
#		$AnimatedSprite.set_sprite_frames(frames)
#		$AnimatedSprite.set_animation("idle")
#	elif avatarID ==3:
#		var frames = preload("res://avatars/Avatar_3.tres")  # default frame
#		$AnimatedSprite.set_sprite_frames(frames)
#		$AnimatedSprite.set_animation("idle")
#	elif avatarID ==4:
#		var frames = preload("res://avatars/Avatar_4.tres")  # default frame
#		$AnimatedSprite.set_sprite_frames(frames)
#		$AnimatedSprite.set_animation("idle")
#	elif avatarID ==5:
#		var frames = preload("res://avatars/Avatar_5.tres")  # default frame
#		$AnimatedSprite.set_sprite_frames(frames)
#		$AnimatedSprite.set_animation("idle")
#	$AnimatedSprite.scale = Vector2(2,2)



