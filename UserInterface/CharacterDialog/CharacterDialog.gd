extends CenterContainer

signal dialog_finished

@export var char_name : String = "Steven"
@export var dialog : String = "Hello World!"
@export var margin_bottom : int = 56
@export var word_delay : float = 0.25

@onready var dialog_label : Label = $PanelContainer/MarginContainer/VBoxContainer/DialogLabel
@onready var name_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/NameLabel

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var button : Button = $PanelContainer/MarginContainer/VBoxContainer/Button

var words_spoken : String = ""
var words_split : Array = []
var i : int = 0

func _ready():
	button.grab_focus()
	button.text = "Skip"
	# Word
	name_label.text = char_name
	append_words_with_timer()
	# Responsive code to Window Size changes
	get_tree().get_root().size_changed.connect(_on_size_changed)
	call_deferred("_on_size_changed")

func _on_size_changed():
	position.y = get_viewport().size.y - size.y - margin_bottom

func append_words_with_timer() -> void:
	words_split = dialog.split(" ")
	get_tree().create_timer(1.0).timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if dialog_label.text == dialog:
		return
	words_spoken += words_split[i] + " "
	dialog_label.text = words_spoken
	i += 1
	if not i == words_split.size():
		get_tree().create_timer(word_delay).timeout.connect(_on_timer_timeout)
	else:
		button.text = "Next"

func _on_resized():
	_on_size_changed()

func _on_button_pressed():
	if button.text == "Skip":
		dialog_label.text = dialog
		button.text = "Next"
		return
	animation_player.current_animation = "FadeOut"
	animation_player.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeOut":
		emit_signal("dialog_finished")
		call_deferred("queue_free")
