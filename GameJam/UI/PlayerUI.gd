extends Control

var stats = ResourceLoader.PlayerStats

func _process(delta):
	$Health.text = "health : " + str(stats.health)
	$Damage.text = "damage : " + str(stats.damage)
