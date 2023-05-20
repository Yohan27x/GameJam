extends Resource
class_name Player_stats

var damage = 1 setget set_damage
var max_damage = 4
var restart_damage
var health = 3 setget set_health
var max_health = 3
var restart_health



signal player_died
signal player_damage_changed(value)
signal player_health_changed(value)


func set_damage(value):
	damage = clamp(value, 0, max_damage)
	emit_signal("player_damage_changed", damage)

func set_health(value):
#	if value < health: # if the new health if inferior than previous health, ie player take damage
#		Events.emit_signal("add_screenshake", 0.75, 0.5)

	health = clamp(value, 0, max_health)
	emit_signal("player_health_changed", health)
	
	if(health == 0):
		emit_signal("player_died")
