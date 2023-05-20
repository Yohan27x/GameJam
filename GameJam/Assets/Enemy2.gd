extends KinematicBody2D


export var ACCELERATION = 25
export var SPEED = 65
export var FRICTION = 12

export(int) var DAMAGE = 0
export(int) var HEALTH = 0
export(Array) var WANDER_TIME = [0.0,0.0]
export(float) var RELOAD_SPEED = 3
export(float) var BULLET_VELOCITY = 2



const PlayerRepered = preload("res://EnemyRepered.tscn")
const HealthItem = preload("res://Assets/HealthItem.tscn")
const DamageItem = preload("res://Assets/DamageItem.tscn")
const Bullet = preload("res://Bullet.tscn")
const DeathEffect = preload("res://EnemyDeathEffect.tscn")
const hitEffect = preload("res://HitEffect.tscn")

var velocity = Vector2.ZERO

var items = [HealthItem, DamageItem]

var LevelInfo = ResourceLoader.LevelInfo

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var stats = $EnemyStats

var player
var is_target
var dt

var wander_vec
var wander_vectors = [Vector2(0,0), Vector2(12.5,10),Vector2(12.5,-10), Vector2(-12.5,10), Vector2(-12.5,-10)]

var target_instance = null

# sound

onready var gunshotfx1 = $GunShotFX1
onready var gunshotfx2 = $GunShotFX2
onready var gunshotfx3 = $GunShotFX3
onready var gunshots = [gunshotfx1, gunshotfx2, gunshotfx3]

func _play_shoot_fx():

	gunshots.shuffle()
	var shot_to_play = gunshots[0]
	shot_to_play.playing = true
	
func _ready():
	$Wander.wait_time = rand_range(WANDER_TIME[0], WANDER_TIME[1])
	$Wander.start()
	
	stats.health = HEALTH
	animationPlayer.play("Idle")

func _process(delta):
	
	target_instance = get_node_or_null("Target")
	
#	print("enemy2 gd")
#	print($Shoot.time_left)
	
	
	if(player != null):
		if(player.global_position.x > global_position.x):
			sprite.scale.x = -1
			$EnemyShadow.scale.x = -1
		else:
			sprite.scale.x = 1
			$EnemyShadow.scale.x = 1
		
	
#	if(player == null):
#		animationPlayer.play("Idle")
#	else:
#		if(is_attacking == false):
#			animationPlayer.play("Run")
	
func _physics_process(delta):
	pass
	
	if(LevelInfo.level_finish == false):
	
		dt = delta * 60
		
		velocity = move_and_slide(velocity)	
			
		if(player != null):
			pass
	
	# if player == nul
	# bouge
	#else
	# bouge plus et tire
	
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
	if(is_target == true):
		if(target_instance != null):  
			target_instance.play = true
		stats.health -= damage
		var effect = Utils.instanceSceneOnMain(hitEffect, global_position)
		effect.z_index = 1
#	print("enemy2 health : " + str(stats.health))

func _on_PlayerZone_body_entered(body):
	if(player == null):
		if(body.name.begins_with("Player")):
			var alert_effect = Utils.instanceSceneOnMain(PlayerRepered, global_position)
			alert_effect.global_position.y -= 25
			player = body
			$Shoot.start()
			
func _on_Shoot_timeout():
	animationPlayer.play("Shoot")
	animationPlayer.queue("Idle")
	$Shoot.wait_time = RELOAD_SPEED
	$Shoot.start()
	
	
func create_bullet():
	if(is_instance_valid(player)):
		var bullet = Utils.instanceSceneOnMain(Bullet, $Sprite/Muzzle.global_position)
		bullet.damage = DAMAGE
		bullet.velocity = (player.global_position - global_position).normalized()
		bullet.velocity *= BULLET_VELOCITY


func _on_EnemyStats_enemy_died():
	var item_pos = global_position
	item_pos.x += rand_range(10,30)
	item_pos.y += rand_range(-30,30)
#	var randomNumber = randi()%10 # will have 0~99
#	if randomNumber == 0:
#		var item = Utils.instanceSceneOnNode(self.get_parent(),items[(randi()%2)], item_pos)
		
	var deatheffect = Utils.instanceSceneOnNode(self.get_parent(),DeathEffect,global_position)
	LevelInfo.enemies_left_in_level -= 1
	print("enemies_left_in_level : " + str(LevelInfo.enemies_left_in_level))
	queue_free()


func _on_Wander_timeout():
	$Wander.wait_time = rand_range(WANDER_TIME[0], WANDER_TIME[1])
	wander()





