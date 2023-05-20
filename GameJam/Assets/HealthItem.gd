extends "res://Assets/Item.gd"


func _on_PickZone_area_entered(area):
	stats.max_health += 1
	stats.health = stats.max_health
	queue_free()
