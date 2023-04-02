extends Area2D



func _on_Area2D_body_entered(body):
	print('change level')
	#Level.current_level += 1
	#Events.emit_signal("change_level", Level.current_level)
