extends StaticBody2D

var level_start
var level_finish
var start_level_reach_timer

onready var colorRect = $Fade
onready var FadeTimer = $Fadeduration
onready var UI = $TimeUI

#Sound
onready var timerEasy = $TimerEasy
onready var timerMiddle = $TimerMiddle
onready var timerHard = $TimerHard
var play_middle_timer = false
var play_hard_timer = false

const DamageItem = preload("res://Assets/DamageItem.tscn")

var LevelInfo = ResourceLoader.LevelInfo
var enemies_left
var enemies_reference

const Target = preload("res://Target.tscn")

var enemy_index_to_choose 

func _ready():
	# refresh the level info 
	
	colorRect.visible = true
	level_start = true
	start_level_reach_timer = false
	
	LevelInfo.level_finish = false
	LevelInfo.timer_in_level = LevelInfo.levels_timer_data[LevelInfo.current_level]
	LevelInfo.enemies_in_level = LevelInfo.levels_enemies_data[LevelInfo.current_level]
	LevelInfo.enemies_left_in_level = LevelInfo.enemies_in_level
	
	randomize()
	enemies_reference = $YSort.get_children()
	enemies_reference.pop_back()
	enemy_index_to_choose = 0
	#var enemy_index_to_choose = randi() % LevelInfo.enemies_left_in_level
#	print(LevelInfo.enemies_left_in_level)
	var target_enemy = enemies_reference[enemy_index_to_choose]
	target_enemy.is_target = true
#	print("target_enemy : " + target_enemy.name)
	Utils.instanceSceneOnNode(target_enemy,Target,target_enemy.global_position)
	
	_play_easy_timer()
	

func _process(delta):

	
	if(LevelInfo.enemies_left_in_level == 0):
		UI.timer.set_paused(true)
		$Exit/Door.visible = false
		$Exit/CollisionShape2D.disabled = true
		# play open door sound
	
	
#	print("LevelInfo.level_finish : " + str(LevelInfo.level_finish))
	
	if(level_start == true and LevelInfo.level_finish == false):
		colorRect.color.a = lerp(colorRect.color.a,0,0.07)
	
	if(LevelInfo.level_finish):
		colorRect.color.a = lerp(colorRect.color.a,1,0.1)
		if(start_level_reach_timer == false):
			# start fade
			FadeTimer.start()
			start_level_reach_timer = true
			
	# SOUND 
	
	if(5 <= LevelInfo.timer_in_level - UI.timer.time_left and LevelInfo.timer_in_level - UI.timer.time_left  < 8):
		play_middle_timer = true
	else:
		play_middle_timer = false
		
	if(8 <=  LevelInfo.timer_in_level - UI.timer.time_left and LevelInfo.timer_in_level - UI.timer.time_left < LevelInfo.timer_in_level):
		play_hard_timer = true
	else:
		play_hard_timer = false
	
	if(play_middle_timer):
		_play_middle_timer()
		
	if(play_hard_timer):
		_play_hard_timer()
			

	


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


func _on_YSort_child_exiting_tree(exit_node):
	if(exit_node.name.begins_with("Enemy") == true):
		if(LevelInfo.enemies_left_in_level != 0 and LevelInfo.level_finish == false):
			enemies_reference = $YSort.get_children()
#			print(enemies_reference)
			var target_enemy = enemies_reference[enemy_index_to_choose +1]
			if(target_enemy.name.begins_with("Enemy")):
				target_enemy.is_target = true
				Utils.instanceSceneOnNode(target_enemy,Target, target_enemy.global_position)
		
func _play_easy_timer():
	timerEasy.playing = true
	timerMiddle.playing = false
	timerHard.playing = false
	
		
func _play_middle_timer():
	timerEasy.playing = false
	timerMiddle.playing = true
	timerHard.playing = false
	play_middle_timer = false
	
func _play_hard_timer():
	timerEasy.playing = false
	timerMiddle.playing = false
	timerHard.playing = true
	play_hard_timer = false
