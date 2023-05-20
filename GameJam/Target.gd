extends Node2D

var play = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position *= 0.5
	global_position.y -= 25
	global_position.x += 15
	
func _process(delta):
	if(play == true):
		$AnimatedSprite.play("effect")

func _on_AnimatedSprite_animation_finished():
	queue_free()
