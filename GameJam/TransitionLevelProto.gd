extends Node2D

var camera_pos = [Vector2(126,98),Vector2(380,98),Vector2(350,350)]
var camera_pos_index = 1
onready var timer = $Timer
onready var camera = $Camera2D

var level_finish = false

func _process(delta):
	
	if(level_finish == true):
		var new_camera_pos = camera_pos[camera_pos_index]
		camera.position = lerp(camera.position, new_camera_pos, 0.04)
		camera.zoom = lerp(camera.zoom, Vector2(2.2,2.2), 0.1)

	if(level_finish == false):
		camera.zoom = lerp(camera.zoom, Vector2(1,1), 0.1)
			

func _on_Timer_timeout():
	level_finish = true
	
func _on_Area2D_area_entered(area):
	level_finish = false
	camera_pos_index += 1
	timer.start(3)
