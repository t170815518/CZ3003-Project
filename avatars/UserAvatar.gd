extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 6
var velocity = Vector2(0, 0)
var sprite_position = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$ClearMessage.connect("timeout", self, "_clear_message")
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
		"method": "move",
		"username": global.username,
		"up": sprite_position[0],
		"right": sprite_position[1], 
		"roomKey": str(global.selected_world)
		}
		print(userInfo)
		Websocket.send(userInfo)

	if Input.is_action_pressed('ui_left'):
		velocity.x = -speed
		sprite_position = get_position()
		var userInfo = {
		"method": "move",
		"username": global.username,
		"up": sprite_position[0],
		"right": sprite_position[1], 
		"roomKey": str(global.selected_world)
		}
		print(userInfo)
		Websocket.send(userInfo)
		
	if Input.is_action_pressed('ui_down'):
		velocity.y = speed
		sprite_position = get_position()
		var userInfo = {
		"method": "move",
		"username": global.username,
		"up": sprite_position[0],
		"right": sprite_position[1], 
		"roomKey": str(global.selected_world)
		}
		print(userInfo)
		Websocket.send(userInfo)

	if Input.is_action_pressed('ui_up'):
		velocity.y = -speed
		sprite_position = get_position()
		var userInfo = {
		"method": "move",
		"username": global.username,
		"up": sprite_position[0],
		"right": sprite_position[1], 
		"roomKey": str(global.selected_world)
		}
		print(userInfo)
		Websocket.send(userInfo)

	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite.set_animation("run")
	else:
		$AnimatedSprite.set_animation("idle")
	move_and_collide(velocity)


func set_message(s):
	$GUI/Message.text = s
	$ClearMessage.start()


func _clear_message():
	$GUI/Message.text = ""
	$ClearMessage.stop()
