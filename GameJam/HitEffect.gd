extends Node2D


func _ready():
	global_position += Vector2(rand_range(-5,5),rand_range(-5,5))
	$AnimatedSprite.play("effect")


func _on_AnimatedSprite_animation_finished():
	queue_free()
