extends CenterContainer

@export var char_name : String = "Steven"
@export var dialog : String = "Hello World!"
@export var margin_bottom : int = 48
@export var word_delay : float = 0.25

@onready var dialog_label : Label = $PanelContainer/MarginContainer/VBoxContainer/DialogLabel
@onready var name_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/NameLabel
@onready var button : Button = $PanelContainer/MarginContainer/VBoxContainer/Button

var words_spoken : String = ""
var words_split : Array = []
var i : int = 0

func _ready():
	name_label.text = char_name
	append_words_with_timer()
	button.text = "Skip"
	# Responsive code to Window Size changes
	get_tree().get_root().size_changed.connect(_on_size_changed)
	call_deferred("_on_size_changed")

func _on_size_changed():
	position.y = get_viewport().size.y - size.y - margin_bottom

func append_words_with_timer() -> void:
	words_split = dialog.split(" ")
	get_tree().create_timer(1.0).timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	words_spoken += words_split[i] + " "
	dialog_label.text = words_spoken
	i += 1
	if not i == words_split.size():
		get_tree().create_timer(word_delay).timeout.connect(_on_timer_timeout)
	else:
		button.text = "Next"

# If the control size changes
func _on_resized():
	_on_size_changed()
