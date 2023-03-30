extends KinematicBody2D


export var ACCELERATION = 500
export var MAX_SPEED = 140
export var ROLL_SPEED = 120
export var FRICTION = 1000

var motion = Vector2.ZERO


func _ready():
	pass
	
func _process(delta):
	pass
	
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	
	if (input_vector != Vector2.ZERO):
		motion = motion.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		motion = motion.move_toward(Vector2.ZERO, FRICTION * delta)
	
	motion = move_and_slide(motion, Vector2(0, 0))
	
	print(input_vector)
	
