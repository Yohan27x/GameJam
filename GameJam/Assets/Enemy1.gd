extends KinematicBody2D

const HealthItem = preload("res://Assets/HealthItem.tscn")
const DamageItem = preload("res://Assets/DamageItem.tscn")

var items = [HealthItem, DamageItem]


onready var stats = $EnemyStats
var LevelInfo = ResourceLoader.LevelInfo

var is_target = false
export(int) var SPEED = 50
var velocity = Vector2.ZERO

func _physics_process(delta):
	# MOVEMENT
	pass
	
#	randomize()
#	velocity.x = rand_range(0,2)
#	velocity.y = rand_range(0,2)
#
#	velocity = move_and_slide(velocity * SPEED)
	
	

func _on_HurtBox_hit(damage):
	
	if(is_target == true):

		stats.health -= damage
#	print("enemy1 health : " + str(stats.health))


func _on_EnemyStats_enemy_died():
	var item = Utils.instanceSceneOnNode(self.get_parent(),items[(randi()%2)], global_position)
	LevelInfo.enemies_left_in_level -= 1
	print("enemies_left_in_level : " + str(LevelInfo.enemies_left_in_level))
	queue_free()
