extends Node2D

var start_fade = false
onready var sprite = $Sprite

	
func _process(delta):
	
	if(start_fade):
		sprite.modulate.a = lerp(sprite.modulate.a,0,0.07)
		sprite.scale = lerp(sprite.scale,Vector2(0.9,0.9),0.15)
	
		
func _on_Timer_timeout():
	start_fade = true
