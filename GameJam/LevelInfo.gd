extends Resource
class_name Level_Info


var current_level = 0
var max_level = 1
var level_finish = false

var levels_enemies_data = [3,2]
var levels_timer_data = [1000,20]

var timer_in_level
var enemies_in_level
var enemies_left_in_level


func go_to_next_level():
	if(current_level < max_level):
		current_level += 1
		enemies_in_level = levels_enemies_data[current_level-1]
		enemies_left_in_level = enemies_in_level
		return true
	else:
		return false
