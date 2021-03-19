extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed =10
export var tilesize=32
onready var sprite=$Sprite
var initpos= Vector2()
var dir =Vector2()
var facing ="down"
var counter =0

var moving=false

# Called when the node enters the scene tree for the first time.
func _ready():
	initpos=position


func _process(delta):
	if not moving:
		set_dir()
	elif dir!=Vector2():
		move(delta)
	else:
		moving=false 	
		
	if facing=="down":	
		sprite.frame=0
	elif facing=="up":
		sprite.frame=13	
	elif facing=="left":	
		sprite.frame=3
	elif facing=="right":
		sprite.frame=15
func set_dir():
	dir=get_dir()
	if dir.x!=0 or dir.y!=0:
		if dir.x>0:
			facing="right"
		elif dir.x<0:
			facing="left"
		elif dir.y>0:
			facing="down"
		else:
			facing="up"
				
		moving=true
		initpos=position 
func get_dir():
	var x=0
	var y=0
	
	if dir.y==0:
		x=int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))	
	if dir.x==0:
		y=int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))	
	return Vector2(x,y)	
func move(delta):
	counter+=delta*speed
	if counter>=1.0:
		position=initpos+dir*tilesize
		counter=0.0
		moving=false
	else :
		position=initpos+dir*tilesize*counter
