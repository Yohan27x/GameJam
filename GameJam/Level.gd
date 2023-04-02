extends StaticBody2D

var level_start
var level_finish
var start_level_reach_timer

onready var colorRect = $Fade
onready var FadeTimer = $Fadeduration
onready var UI = $TimeUI

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
	print(LevelInfo.enemies_left_in_level)
	var target_enemy = enemies_reference[enemy_index_to_choose]
	target_enemy.is_target = true
	print("target_enemy : " + target_enemy.name)
	Utils.instanceSceneOnNode(target_enemy,Target,target_enemy.global_position)
	

func _process(delta):

	
	if(LevelInfo.enemies_left_in_level == 0):
		UI.timer.set_paused(true)
		$StaticBody2D/Door.visible = false
		$StaticBody2D/CollisionShape2D.disabled = true
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


func _on_Enemy1_tree_exited():
	pass
#	print("enemy1 exited tree")
#	enemies_reference = $YSort.get_children()
#	if(LevelInfo.enemies_left_in_level != 0):
#		var enemy_index_to_choose = randi() % LevelInfo.enemies_left_in_level
#		var target_enemy = enemies_reference[enemy_index_to_choose]
#		target_enemy.is_target = true
#		Utils.instanceSceneOnNode(target_enemy,Target,target_enemy.global_position)


func _on_Enemy2_tree_exited():
	pass
#	print("enemy2 exited tree")
#	enemies_reference = $YSort.get_children()
#	if(LevelInfo.enemies_left_in_level != 0):
#		var enemy_index_to_choose = randi() % LevelInfo.enemies_left_in_level
#		var target_enemy = enemies_reference[enemy_index_to_choose]
#		target_enemy.is_target = true
#		Utils.instanceSceneOnNode(target_enemy,Target, target_enemy.global_position)
	

func _on_YSort_child_exiting_tree(exit_node):
	if(exit_node.name.begins_with("Enemy") == true):
		if(LevelInfo.enemies_left_in_level != 0 and LevelInfo.level_finish == false):
			enemies_reference = $YSort.get_children()
			print(enemies_reference)
			var target_enemy = enemies_reference[enemy_index_to_choose +1]
			if(target_enemy.name.begins_with("Enemy")):
				target_enemy.is_target = true
				Utils.instanceSceneOnNode(target_enemy,Target, target_enemy.global_position)
	#		var enemy_index_to_choose = randi() % LevelInfo.enemies_left_in_level
	#		var target_enemy = enemies_reference[enemy_index_to_choose]
	#		if(target_enemy.name.begins_with("Enemy")):
	#			print("next target :" + target_enemy.name)
	#			target_enemy.is_target = true
	#			Utils.instanceSceneOnNode(target_enemy,Target, target_enemy.global_position)
