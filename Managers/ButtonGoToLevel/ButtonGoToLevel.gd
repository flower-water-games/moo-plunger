extends Node

@export var button : Button
@export var level_path : String = ("res://UserInterface/MainMenu/MainMenu.tscn")

@export var web_build : bool = false
func _ready():
	button.pressed.connect(_go_to_level)

func _go_to_level():
	print("go to: " + level_path)
	if web_build:
		if OS.get_name() == "Web":
			get_tree().change_scene_to_file("res://Levels/web_lit_level.tscn")
			print("Web")
			return
	get_tree().change_scene_to_file(level_path)
	print("Not Web")

