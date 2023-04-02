extends KinematicBody2D


export var ACCELERATION = 500
export var SPEED = 150
export var FRICTION = 1000


var input_vector = Vector2.ZERO

var LevelInfo = ResourceLoader.LevelInfo
var stats = ResourceLoader.PlayerStats


onready var Animationtree = $AnimationTree

func _ready():
	pass
	
func _process(delta):
	pass
	 
#	print($HitBox.damage)

	
func _physics_process(delta):
	
	var velocity = Vector2.ZERO
	
	if(LevelInfo.level_finish == false):
	
		if(Input.is_action_pressed("ui_right")):
			velocity.x += 1.0
		if(Input.is_action_pressed("ui_left")):
			velocity.x -= 1.0
		if(Input.is_action_pressed("ui_up")):
			velocity.y -= 1.0
		if(Input.is_action_pressed("ui_down")):
			velocity.y += 1.0
			
		velocity = velocity.normalized()
		
		velocity = move_and_slide(velocity * SPEED)
		
		if velocity == Vector2.ZERO:
			Animationtree.get("parameters/playback").travel("Idle")
		else:
			Animationtree.set("parameters/Idle/blend_position", velocity)
			Animationtree.set("parameters/Run/blend_position", velocity)
			Animationtree.get("parameters/playback").travel("Run")
		

func _on_HurtBox_hit(damage):
	pass
#	print("player _on_HurtBox_hit ")
