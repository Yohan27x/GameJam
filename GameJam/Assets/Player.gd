extends KinematicBody2D


export var ACCELERATION = 40
export var MAX_SPEED = 140
export var ROLL_SPEED = 120
export var FRICTION = 12


var input_vector = Vector2.ZERO

var LevelInfo = ResourceLoader.LevelInfo
var stats = ResourceLoader.PlayerStats


onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

enum {
	MOVE,
	ROLL,
	ATTACK,
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN


func _physics_process(delta): # physics process if need to touch positon or whatever of the player

	match state:
		MOVE:
			moves_state(delta)
#		ROLL:
#			roll_state(delta)
#		ATTACK:
#			attack_state(delta)
	

func moves_state(delta):
	
	if(LevelInfo.level_finish == false):
	
		var dt = delta * 60

		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

		input_vector = input_vector.normalized()

		if (input_vector != Vector2.ZERO):
	#		roll_vector = input_vector
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationTree.set("parameters/Attack/blend_position", input_vector)
			animationTree.set("parameters/Roll/blend_position", input_vector)
			animationState.travel("Run")
			
			#velocity += input_vector * ACCELERATION * dt
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * dt)
			#print(velocity)
		else:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * dt)
			

		move()
	
#	if Input.is_action_just_pressed("attack"):
#		state = ATTACK
#
#	if Input.is_action_just_pressed("Roll"):
#		state = ROLL


func move():
	velocity = move_and_slide(velocity)
		

func _on_HurtBox_hit(damage):
	pass
#	print("player _on_HurtBox_hit ")
