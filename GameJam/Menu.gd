extends Control

var LevelInfo = ResourceLoader.LevelInfo

func _ready():
	pass
#	VisualServer.set_default_clear_color(Color.black)

func _on_Start_pressed():
	$click.play()
	get_tree().change_scene("res://Level"+str(LevelInfo.current_level)+".tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Start_mouse_entered():
	$hover.play()


func _on_Quit_mouse_entered():
	$hover.play()

