extends Node2D


var velocity = Vector2(0,0)

var damage
onready var hitbox = $HitBox


func _physics_process(delta):
	position += velocity * delta
	
func _process(delta):
	hitbox.damage = damage

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_HitBox_area_entered(area):
	queue_free()
