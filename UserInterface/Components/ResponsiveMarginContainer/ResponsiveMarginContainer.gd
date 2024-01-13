extends MarginContainer

@export var padding : int = 64

func _ready():
	# Set the padding
	add_theme_constant_override("margin_top", padding)
	add_theme_constant_override("margin_left", padding)
	add_theme_constant_override("margin_bottom", padding)
	add_theme_constant_override("margin_right", padding)
	# Responsive code to Window Size changes
	get_tree().get_root().size_changed.connect(_on_size_changed)
	call_deferred("_on_size_changed")

func _on_size_changed():
	size = get_viewport().size
