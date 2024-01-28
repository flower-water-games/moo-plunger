extends Node

@export var button : Button
@export var level_path : String = ("res://UserInterface/MainMenu/MainMenu.tscn")

func _ready():
	button.pressed.connect(_go_to_level)

func _go_to_level():
	print("go to: " + level_path)
	get_tree().change_scene_to_file(level_path)
