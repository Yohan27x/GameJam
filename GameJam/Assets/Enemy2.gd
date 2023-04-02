extends KinematicBody2D

const HealthItem = preload("res://Assets/HealthItem.tscn")
const DamageItem = preload("res://Assets/DamageItem.tscn")

var items = [HealthItem, DamageItem]

var LevelInfo = ResourceLoader.LevelInfo
var is_target = false

onready var stats = $EnemyStats


func _process(delta):
	pass
	# MOVEMENT
	
func _on_HurtBox_hit(damage):
	
	if(is_target == true):
		stats.health -= damage
#	print("enemy2 health : " + str(stats.health))

func _on_EnemyStats_enemy_died():
	var item = Utils.instanceSceneOnNode(self.get_parent(),items[(randi()%2)], global_position)
	LevelInfo.enemies_left_in_level -= 1
	queue_free()
