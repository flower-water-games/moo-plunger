extends Node

@export var node_1 : Control
@export var node_2 : Control
@export var node_3 : Control
@export var node_4 : Control
@export var node_5 : Control

var node_list : Array = []

func _ready():
	# Responsive code to Window Size changes
	get_tree().get_root().size_changed.connect(_on_size_changed)
	call_deferred("_on_size_changed")
	# Remove unused nodes
	var all_nodes : Array = [node_1, node_2, node_3, node_4, node_5]
	for child in all_nodes:
		if not child == null:
			node_list.push_back(child)

func _on_size_changed():
	for child in node_list:
		child.size = get_viewport().size
