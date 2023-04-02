extends KinematicBody2D

const HealthItem = preload("res://Assets/HealthItem.tscn")
const DamageItem = preload("res://Assets/DamageItem.tscn")

var LevelInfo = ResourceLoader.LevelInfo

onready var stats = $EnemyStats

var items = [HealthItem, DamageItem]

func _process(delta):
	pass
	# MOVEMENT
	

func _on_HurtBox_hit(damage):
	stats.health -= damage
	print("enemy2 health : " + str(stats.health))

func _on_EnemyStats_enemy_died():
	var item = Utils.instanceSceneOnNode(get_parent(), items[(randi()%2)], global_position)
	LevelInfo.enemies_left_in_level -= 1
	queue_free()
