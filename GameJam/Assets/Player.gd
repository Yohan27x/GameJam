extends KinematicBody2D


var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

export var ACCELERATION = 40
export var SPEED = 100
export var FRICTION = 12

export(int) var DAMAGE = 1

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

var LevelInfo = ResourceLoader.LevelInfo
var stats = ResourceLoader.PlayerStats

const hitEffect = preload("res://HitEffect.tscn")


var is_attacking setget set_attack
var dead = false


var play_step_sound = false
onready var step1 = $Step1
onready var step2 = $Step2
onready var step3 = $Step3
onready var step4 = $Step4
onready var step5 = $Step5
onready var steps = [step1,step2,step3,step4,step5]

var play_attack_sound = false
onready var attack1 = $Attack1
onready var attack2 = $Attack2
onready var attack3 = $Attack3
onready var attacks = [attack1,attack2,attack3]


func _play_step_fx():
	steps.shuffle()
	var fx_to_play = steps[0]
	fx_to_play.playing = true
	
func _play_attack_fx():
	attacks.shuffle()
	var attack_to_play = attacks[0]
	attack_to_play.playing = true
	
func set_attack(value):
	is_attacking = value
	
func _ready():
	is_attacking = false
	$PlayerShadow.visible = true
	$Sprite.visible = true
	
	stats.damage = DAMAGE
	$HitBox.damage = stats.damage

func _physics_process(delta): # physics process if need to touch positon or whatever of the player

	moves_state(delta)


func moves_state(delta):
	
	if(LevelInfo.level_finish == false):
	
		var dt = delta * 60

		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

		input_vector = input_vector.normalized()
		
		if(stats.health != 0):
			if(is_attacking == false):
				if(input_vector != Vector2.ZERO):
					$HitBox/CollisionShape2D.disabled = true
					if(input_vector.x > 0):
						sprite.scale.x = 1
						$HitBox.global_position.x = 10 + global_position.x
					elif(input_vector.x < 0):
						sprite.scale.x = -1
						$HitBox.global_position.x = -8 + global_position.x
					animationPlayer.play("Run")
					velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * dt)
					
				else:
					animationPlayer.play("Idle")
					velocity = velocity.move_toward(Vector2.ZERO, FRICTION * dt)
					
				move()
			else:
				animationPlayer.play("Attack")
				velocity = Vector2.ZERO
		else:
			if(dead == false):
				animationPlayer.play("Dead")
			dead = true

	
	if Input.is_action_just_pressed("ui_attack"):
		is_attacking = true
		

func move():
	velocity = move_and_slide(velocity)
		

func _on_HurtBox_hit(damage):
	stats.health -= damage
	var effect = Utils.instanceSceneOnMain(hitEffect, global_position)
	$GetAttacked.playing = true
	effect.z_index = 1
	

func _play_death_sound():
	$Lose.playing = true

func _game_over():
	LevelInfo.player_alive = false
	get_tree().change_scene("res://UI/GameOverScene.tscn")

func _on_Lose_finished():
	_game_over()



	
