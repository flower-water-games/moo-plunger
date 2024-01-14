@tool
extends Control

@export var window_title : String = "Title"
@export var min_size : Vector2 = Vector2(936, 0)

@onready var window_container : PanelContainer = $MarginContainer/CenterContainer/PanelContainer
@onready var label : Label = $MarginContainer/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	_update()

func _process(delta):
	if Engine.is_editor_hint():
		_update()
	else:
		set_process(false)

func _update():
	label.text = window_title
	window_container.set_custom_minimum_size(min_size)
