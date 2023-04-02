extends KinematicBody2D

const HealthItem = preload("res://Assets/HealthItem.tscn")
const DamageItem = preload("res://Assets/DamageItem.tscn")

var items = [HealthItem, DamageItem]

onready var stats = $EnemyStats

var LevelInfo = ResourceLoader.LevelInfo

func _process(delta):
	# MOVEMENT
	pass
	

func _on_HurtBox_hit(damage):
#	print("enemy1 _on_HurtBox_hit")
	stats.health -= damage
	print("enemy1 health : " + str(stats.health))


func _on_EnemyStats_enemy_died():
	var item = Utils.instanceSceneOnNode(get_parent(), items[(randi()%2)], global_position)
	LevelInfo.enemies_left_in_level -= 1
	print("enemies_left_in_level : " + str(LevelInfo.enemies_left_in_level))
	queue_free()
