@tool
extends PanelContainer

@export var icon_color : Color = "#ffffff"
@export var button_color : Color = "#ffffff"

enum InputType { CONTROLLER, KEYBOARD, MOUSE }
@export var input_type : InputType
var current_input_type = input_type

@export var action : String = "Press"
@export var button : String = "Space"
@export var description : String = "to Jump"

@onready var icon : TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label_action : Label = $MarginContainer/HBoxContainer/HBoxContainer/LabelAction
@onready var panel_button : PanelContainer = $MarginContainer/HBoxContainer/HBoxContainer/PanelContainer
@onready var label_button : Label = $MarginContainer/HBoxContainer/HBoxContainer/PanelContainer/MarginContainer/LabelButton
@onready var label_description : Label = $MarginContainer/HBoxContainer/HBoxContainer/LabelDescription

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_button()
	
func _update_button():
	label_action.text = action
	label_button.text = button
	label_description.text = description
	
	icon.self_modulate = icon_color
	panel_button.self_modulate = button_color
	
	if not current_input_type == input_type:
		match input_type:
			InputType.CONTROLLER:
				icon.texture = load("res://Assets/UIControls/Controller.png")
			InputType.KEYBOARD:
				icon.texture = load("res://Assets/UIControls/Keyboard.png")
			InputType.MOUSE:
				icon.texture = load("res://Assets/UIControls/Mouse.png")
		# Set to match
		current_input_type = input_type

func _process(delta):
	if Engine.is_editor_hint():
		_update_button()
	else:
		set_process(false)
