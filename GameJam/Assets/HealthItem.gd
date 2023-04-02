extends "res://Assets/Item.gd"


func _on_PickZone_area_entered(area):
	stats.health += 1
	queue_free()
