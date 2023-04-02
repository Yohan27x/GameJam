extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position *= 0.5
	global_position.y -= 25
	
func _process(delta):

	var tween = create_tween()
	tween.tween_property($Sprite, "scale", Vector2(0,0), 0.5).set_ease(Tween.EASE_IN)
	
