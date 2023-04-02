extends StaticBody2D

var level_start
var level_finish
var start_level_reach_timer

onready var colorRect = $Fade
onready var FadeTimer = $Fadeduration
onready var UI = $TimeUI

var LevelInfo = ResourceLoader.LevelInfo

var enemies_left

func _ready():
	# refresh the level info 
	
	colorRect.visible = true
	level_start = true
	start_level_reach_timer = false
	
	LevelInfo.level_finish = false
	LevelInfo.timer_in_level = LevelInfo.levels_timer_data[LevelInfo.current_level]
	LevelInfo.enemies_in_level = LevelInfo.levels_enemies_data[LevelInfo.current_level]
	LevelInfo.enemies_left_in_level = LevelInfo.enemies_in_level
	

func _process(delta):
	
	if(LevelInfo.enemies_left_in_level == 0):
		UI.timer.set_paused(true)
	
	
	print("LevelInfo.level_finish : " + str(LevelInfo.level_finish))
	
	if(level_start == true and LevelInfo.level_finish == false):
		colorRect.color.a = lerp(colorRect.color.a,0,0.07)
	
	if(LevelInfo.level_finish):
		colorRect.color.a = lerp(colorRect.color.a,1,0.1)
		if(start_level_reach_timer == false):
			# start fade
			FadeTimer.start()
			start_level_reach_timer = true
			

func _on_ChangeLevel_body_entered(body):
	if(LevelInfo.enemies_left_in_level == 0):
		LevelInfo.level_finish = true

# Fade
func _on_TimeRemain_timeout():
	if(LevelInfo.go_to_next_level()):
		get_tree().change_scene("res://Level"+str(LevelInfo.current_level)+".tscn")

# levelTimer
func _on_Timer_timeout():
	if(LevelInfo.level_finish == false):
		$GameOver.visible = true
