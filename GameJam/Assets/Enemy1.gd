extends KinematicBody2D


export var ACCELERATION = 25
export var SPEED = 65
export var FRICTION = 12


export(int) var DAMAGE = 0
export(int) var HEALTH = 0
export(Array) var WANDER_TIME = [0.0,0.0]
export(float) var TIME_ATTACK_AGAIN = 3



var velocity = Vector2.ZERO

var LevelInfo = ResourceLoader.LevelInfo

const PlayerRepered = preload("res://EnemyRepered.tscn")
const HealthItem = preload("res://Assets/HealthItem.tscn")
const DamageItem = preload("res://Assets/DamageItem.tscn")
const DeathEffect = preload("res://EnemyDeathEffect.tscn")
const hitEffect = preload("res://HitEffect.tscn")

var items = [HealthItem, DamageItem]

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var stats = $EnemyStats

var player
var is_attacking setget set_attacking
var is_target

var dt

var wander_vec
var wander_vectors = [Vector2(0,0), Vector2(25,0),Vector2(-25,0), Vector2(0,-25), Vector2(0,25)]

onready var attackfx1 = $AttackFx1
onready var attackfx2 = $AttackFx2
onready var attackfx3 = $AttackFx3
onready var attackFxs = [attackfx1, attackfx2, attackfx3]

var target_instance = null



func _ready():
	$HitBox/CollisionShape2D.disabled = true
	is_attacking = false

	$Wander.wait_time = rand_range(WANDER_TIME[0], WANDER_TIME[1])
	$Wander.start()
	
	stats.damage = DAMAGE
	$HitBox.damage = stats.damage
	stats.health = HEALTH

func _play_attack_fx():

	attackFxs.shuffle()
	var fx_to_play = attackFxs[0]
	fx_to_play.playing = true
	
func set_attacking(value):
	is_attacking = value

	
func _process(delta):
	
	target_instance = get_node_or_null("Target")
	
	
	if(player != null):
		$AttackPlayerZone/CollisionShape2D.disabled = false
	
	
	if(velocity.x > 0):
		sprite.scale.x = -1
		$HitBox.global_position.x = global_position.x + 17
		$EnemyShadow.scale.x = -1
	elif(velocity.x < 0):
		sprite.scale.x = 1
		$HitBox.global_position.x = -10 + global_position.x 
		$EnemyShadow.scale.x = 1
	
	if(player == null):
		animationPlayer.play("Idle")
	else:
		if(is_attacking == false):
			animationPlayer.play("Run")


func _physics_process(delta): 

	if(LevelInfo.level_finish == false):
	
		dt = delta * 60
		
#		if(LevelInfo.player_alive == true):
		if(player != null):
			seek()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * dt)
#		else:
#			player = null
#			wander()

		velocity = move_and_slide(velocity)	
		
	
func seek():

	var desired = player.global_position - global_position
	desired = desired.normalized()
	desired *= SPEED
	var steer = desired - velocity
	steer = steer.limit_length(13)
	add_force(steer)
	

func wander():
	if(player == null):
		wander_vectors.shuffle()
		var new_vec = wander_vectors[0]
		
		while(new_vec == wander_vec):
			wander_vectors.shuffle()
			new_vec = wander_vectors[0]
			
		wander_vec = new_vec
#		print("wander_vec : " + str(wander_vec))
		velocity = Vector2(0,0)
		add_force(wander_vec)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * dt)
		
		
func add_force(force):
	velocity += force
	
	
func _on_HurtBox_hit(damage):
	if(is_target):
		if(target_instance != null):  
			target_instance.play = true
		print("enenm1 gd take damage")
		stats.health -= damage
		var effect = Utils.instanceSceneOnMain(hitEffect, global_position)
		effect.z_index = 1

func _on_Timer_timeout():
	var rand_time = rand_range(WANDER_TIME[0], WANDER_TIME[1])
	print(rand_time)
	$Wander.wait_time = rand_time
	wander()


func _on_PlayerZone_body_entered(body):
	if(player == null):
		if(body.name.begins_with("Player")):
			player = body
			var instance_position = global_position
			instance_position.y -= 25
			var alert_effect = Utils.instanceSceneOnMain(PlayerRepered, instance_position)


func _on_AttackPlayerZone_body_entered(body):
	if(body.name.begins_with("Player")):
		$StartAttack.start()
			
			
	

func _on_AttackPlayerZone_body_exited(body):
	if(body.name.begins_with("Player")):
		if(animationPlayer.get_current_animation() != "Attack"):
			is_attacking = false


func _on_StartAttack_timeout():
	animationPlayer.play("Attack")
	animationPlayer.queue("RESET")
	is_attacking = true
	$StartAttack.wait_time = TIME_ATTACK_AGAIN
	$StartAttack.start()
	
	
func _on_EnemyStats_enemy_died():
	var item_pos = global_position
	item_pos.x += rand_range(10,30)
	item_pos.y += rand_range(-30,30)
#	var randomNumber = randi()%5 # will have 0~99
#	if randomNumber == 0:
#		var item = Utils.instanceSceneOnNode(self.get_parent(),items[(randi()%2)], item_pos)
		
	var deatheffect = Utils.instanceSceneOnNode(self.get_parent(),DeathEffect,global_position)
	LevelInfo.enemies_left_in_level -= 1
	print("enemies_left_in_level : " + str(LevelInfo.enemies_left_in_level))
	queue_free()

