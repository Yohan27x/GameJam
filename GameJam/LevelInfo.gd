extends Resource
class_name Level_Info


var current_level = 1
var max_level = 9
var level_finish = false

var levels_enemies_data = [1,2,3,3,2,3,4,3,4,5]
var levels_timer_data = [10,15,15,18,18,14,16,17,18,19]
var timer_dfficulty = [[5,7],[5,11],[5,12], [7,14], [7,14], [5,9], [7,12], [8,13], [8,14], [8,15]]

var timer_easy_duration
var timer_middle_duration

var timer_in_level
var enemies_in_level
var enemies_left_in_level
var player_alive

var display_game_over = false



var timer_out_check


func up_var():
	current_level += 1
	enemies_in_level = levels_enemies_data[current_level-1]
	enemies_left_in_level = enemies_in_level

func go_to_next_level():
	if(current_level < max_level):
		return true
	else:
		return false
