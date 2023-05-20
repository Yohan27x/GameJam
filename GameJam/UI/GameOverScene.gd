extends Control

var LevelInfo = ResourceLoader.LevelInfo
var stats = ResourceLoader.PlayerStats

func _process(delta):
	$ColorRect.color.a = lerp($ColorRect.color.a,1,0.1)


func _on_Start_pressed():
	stats.health = stats.restart_health
	stats.damage = stats.restart_damage
	get_tree().change_scene("res://Level"+str(LevelInfo.current_level)+".tscn")
