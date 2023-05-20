extends "res://Assets/Item.gd"


func _on_PickZone_area_entered(area):
	stats.damage += 1
	print("in item gd : " + str(stats.damage))
	queue_free()
