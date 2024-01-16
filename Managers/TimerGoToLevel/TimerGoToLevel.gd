extends Timer

@export var level_path : String = "res://UserInterface/MainMenu/MainMenu.tscn"

func _on_timeout():
	get_tree().change_scene_to_file(level_path)
