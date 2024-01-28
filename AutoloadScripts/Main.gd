extends Node

signal cow_dead

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("close_game"):
			# get_tree().quit()
			game_over()
			get_tree().change_scene("res://UserInterface/MainMenu/TitleScreen.tscn")
			pass

func game_over():
	print('game over!')
	#get_tree().change_scene("res://Levels/GameOver.tscn")