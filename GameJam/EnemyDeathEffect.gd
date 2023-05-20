extends Node2D

onready var animatedSprite = $AnimatedSprite

func _ready():
	$DeadSFX.playing = true

func _process(delta):
	animatedSprite.play("Effect")
	

