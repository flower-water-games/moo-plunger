extends Node

@export var button : Button
@export var level_path : String = ("res://UserInterface/MainMenu/MainMenu.tscn")
@export var textures: Array[Texture] = [] 
@export var panel : PanelContainer
@export var stylebox : StyleBoxTexture

var index : int = 0

func _ready():
	button.pressed.connect(_proceed)
	
	_set_index(index)
	
	#print(len(textures))
	
func _proceed(): 
	if index < len(textures) - 1: 
		index += 1
		_set_index(index)
	else:
		_go_to_level()

func _set_index(i : int):
	var new_stylebox : StyleBoxTexture = stylebox.duplicate() as StyleBoxTexture
	new_stylebox.texture = textures[i]
	panel.add_theme_stylebox_override("panel", new_stylebox)
	
func _go_to_level():
	print("go to: " + level_path)
	get_tree().change_scene_to_file(level_path)
