extends Node

signal cow_dead

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("close_game"):
			# get_tree().quit()
			game_over()

func game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://UserInterface/MainMenu/TitleScreen.tscn")
	#get_tree().change_scene("res://Levels/GameOver.tscn")
