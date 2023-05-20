extends Control

var PlayerStats = ResourceLoader.PlayerStats


onready var health = $Health
onready var damage = $Damage


func _ready():
	PlayerStats.connect("player_health_changed", self, "on_player_health_changed")
	PlayerStats.connect("player_damage_changed", self, "on_player_damage_changed")
	PlayerStats.connect("player_died", self, "_on_player_died")
	health.rect_size.x = PlayerStats.health * 16
	damage.rect_size.x = PlayerStats.damage * 16
	
func on_player_health_changed(value):
	health.rect_size.x = value * 16
	
func on_player_damage_changed(value):
	print("ui gd / damage changed :" )

	damage.rect_size.x = value * 16
	
func _on_player_died():
	health.visible = false
	damage.visible = false
	

