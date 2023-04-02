extends Area2D

export(int) var damage = 1
var stats = ResourceLoader.PlayerStats

func _process(delta):
	damage = stats.damage

func _on_HitBox_area_entered(hurtbox):
	hurtbox.emit_signal("hit", damage)
#	print('_on_HitBox_area_entered')
