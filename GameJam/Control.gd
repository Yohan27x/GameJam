extends Control

onready var label = $Label
onready var timer = $Timer

var LevelInfo = ResourceLoader.LevelInfo

onready var animationPlayer = $AnimationPlayer

func _ready():
	timer.wait_time = LevelInfo.levels_timer_data[LevelInfo.current_level]
	timer.start()

func _process(delta):
	
	if(LevelInfo.level_finish == false):
		
		label.modulate.a = lerp(label.modulate.a, 1, 0.05)
		var time = str(timer.time_left)
		var roundtime = int(time)
		label.text = str(roundtime)
		
		
#		var font = label.get_font("font")
#		var tween = get_tree().create_tween()
#		tween.tween_property(font, 'size', 60, 5)
#
#		animationPlayer.play("SizeChange")
#		animationPlayer.queue("RESET")		

	
		
	else:
		label.modulate.a = lerp(label.modulate.a, 0, 0.05)


