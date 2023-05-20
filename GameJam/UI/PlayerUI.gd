extends CanvasLayer

var stats = ResourceLoader.PlayerStats

func _ready():
	stats.connect("player_health_changed", self, "on_player_health_changed")

func _process(delta):
	pass

