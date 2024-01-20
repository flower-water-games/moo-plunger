extends Node



func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("close_game"):
			get_tree().quit()
