extends StaticBody2D

var level_start
var level_finish
var start_level_reach_timer

onready var colorRect = $Fade
onready var FadeTimer = $Fadeduration
onready var UI = $TimeUI
onready var LevelTimer = $TimeUI/Timer

var stats = ResourceLoader.PlayerStats

var LevelInfo = ResourceLoader.LevelInfo
var enemies_left
var enemies_reference

const Target = preload("res://Target.tscn")

var enemy_index_to_choose 

onready var timerEasy = $TimerEasy
onready var timerMiddle = $TimerMiddle
onready var timerHard = $TimerHard
onready var timeOut = $TimerOut

var play_easy_timer = false
var play_middle_timer = false
var play_hard_timer = false
var play_time_out_sound = false

var play_sound_all_enemies_clear = false
var play_sound_next_level_sound = false


func _ready():
	# refresh the level info 
	
	
	LevelInfo.timer_easy_duration = LevelInfo.timer_dfficulty[LevelInfo.current_level][0]
	LevelInfo.timer_middle_duration = LevelInfo.timer_dfficulty[LevelInfo.current_level][1]

	play_easy_timer = false
	play_middle_timer = false
	play_hard_timer = false
	
	
	play_sound_all_enemies_clear = false
	play_sound_next_level_sound = false
	
	stats.restart_health = stats.health
	stats.restart_damage = stats.damage
	
	colorRect.visible = true
	level_start = true
	start_level_reach_timer = false
	
	LevelInfo.display_game_over = false
	
	LevelInfo.player_alive = true
	LevelInfo.level_finish = false
	LevelInfo.timer_in_level = LevelInfo.levels_timer_data[LevelInfo.current_level]
	LevelInfo.timer_out_check = false
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
	
#	_play_easy_timer()
	

func _process(delta):
	
	if(LevelTimer.time_left < 1):
		if(LevelInfo.level_finish == false):
			LevelInfo.timer_out_check = true
		
	
#	print("current level :", str(LevelInfo.current_level))
	
	if(stats.health == 0):
		LevelInfo.player_alive = false
	
	
	if(0 <= LevelInfo.timer_in_level - UI.timer.time_left and LevelInfo.timer_in_level - UI.timer.time_left  < LevelInfo.timer_easy_duration):
		if(play_easy_timer == false):
			timerEasy.play()
			play_easy_timer = true
	if( LevelInfo.timer_easy_duration <= LevelInfo.timer_in_level - UI.timer.time_left and LevelInfo.timer_in_level - UI.timer.time_left  <  LevelInfo.timer_middle_duration):
		if(play_middle_timer == false):
				timerEasy.stop()
				timerMiddle.play()
				play_middle_timer = true
				
	if(LevelInfo.timer_middle_duration <= LevelInfo.timer_in_level - UI.timer.time_left and LevelInfo.timer_in_level - UI.timer.time_left < LevelInfo.timer_in_level):
		if(play_hard_timer == false):
			timerMiddle.stop()
			timerHard.play()
			print("iin")
			play_hard_timer = true
				
	
	if(LevelInfo.timer_out_check == true):
		if(play_time_out_sound == false):
			timerHard.stop()
			timeOut.play()
			play_time_out_sound = true
			stats.health = 0

	
	if(LevelInfo.enemies_left_in_level == 0):
		timerEasy.stop()
		timerMiddle.stop()
		timerHard.stop()
		UI.timer.set_paused(true)
		if(play_sound_all_enemies_clear == false):
			$AllDiedSFX.playing = true
			play_sound_all_enemies_clear = true
			
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
			

func _on_ChangeLevel_body_entered(body):
	
	if(LevelInfo.current_level == 9):
		get_tree().quit()
		
	if(LevelInfo.enemies_left_in_level == 0):
		LevelInfo.level_finish = true
		

# Fade
func _on_TimeRemain_timeout():
	if(LevelInfo.go_to_next_level()):
		if(play_sound_next_level_sound == false):
			$NextLevelSFX.playing = true
			play_sound_next_level_sound = true
		
		

func _on_YSort_child_exiting_tree(exit_node):
	if(exit_node.name.begins_with("Enemy") == true):
		if(LevelInfo.enemies_left_in_level != 0 and LevelInfo.level_finish == false):
			enemies_reference = $YSort.get_children()
			var target_enemy = enemies_reference[enemy_index_to_choose+1]
			if(target_enemy.name.begins_with("Enemy")):
				target_enemy.is_target = true
				var target_enemy_position = target_enemy.global_position
				Utils.instanceSceneOnNode(target_enemy,Target,target_enemy_position)
				

func _on_NextLevelSFX_finished():
	
	LevelInfo.up_var()
	get_tree().change_scene("res://Level"+str(LevelInfo.current_level)+".tscn")


