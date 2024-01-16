extends Node

@export var set_node : Control
@export var fit_width : bool = true	
@export var fit_height : bool = true
@export var reset_size : bool = true

func _ready():
	# Responsive code to Window Size changes
	get_tree().get_root().size_changed.connect(_on_size_changed)
	call_deferred("_on_size_changed")

func _on_size_changed():
	# Reset -- Not sure why this is neccessary but it seems to be.
	if reset_size:
		set_node.size = Vector2(0,0)
	# Auto-sizing
	if fit_width:
		set_node.size.x = get_viewport().size.x
	if fit_height:
		set_node.size.y = get_viewport().size.y
