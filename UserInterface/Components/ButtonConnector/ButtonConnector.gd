extends Node

@export var initial_button : Button

@export var press_left_button : Button
@export var press_up_button : Button
@export var press_right_button : Button
@export var press_down_button : Button

func _ready():
	#initial_button = get_parent()
	pass

func _input(event):
	if initial_button.has_focus():
		if event is InputEventKey:
			call_deferred("_pressed_grab_focus", event, "ui_left", press_left_button)
			call_deferred("_pressed_grab_focus", event, "ui_up", press_up_button)
			call_deferred("_pressed_grab_focus", event, "ui_right", press_right_button)
			call_deferred("_pressed_grab_focus", event, "ui_down", press_down_button)

func _pressed_grab_focus(event, input_name, _button):
	if event.is_action_pressed(input_name):
		if not _button == null:
			_button.grab_focus()
