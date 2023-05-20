extends KinematicBody2D


const HealthItem = preload("res://Assets/HealthItem.tscn")
const DamageItem = preload("res://Assets/DamageItem.tscn")
const DeathEffect = preload("res://EnemyDeathEffect.tscn")
const hitEffect = preload("res://HitEffect.tscn")

var items = [HealthItem, DamageItem]

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var stats = $EnemyStats

var is_target

var LevelInfo = ResourceLoader.LevelInfo

func _process(delta):
	pass

func _on_HurtBox_hit(damage):
	if(is_target):
		stats.health -= damage
		print("tank enemy gd / health "+ str(stats.health))
		var effect = Utils.instanceSceneOnMain(hitEffect, global_position)
		effect.z_index = 1


func _on_EnemyStats_enemy_died():
	var item_pos = global_position
	item_pos.x += rand_range(10,30)
	item_pos.y += rand_range(-30,30)
#	var randomNumber = randi()%5 # will have 0~99
#	if (randomNumber == 0):
#		var item = Utils.instanceSceneOnNode(self.get_parent(),items[(randi()%2)], item_pos)
	var deatheffect = Utils.instanceSceneOnNode(self.get_parent(),DeathEffect,global_position)
	LevelInfo.enemies_left_in_level -= 1
	print("enemies_left_in_level : " + str(LevelInfo.enemies_left_in_level))
	queue_free()
