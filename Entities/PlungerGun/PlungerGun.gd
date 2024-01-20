extends Node3D

var plunger_scene = load("res://Entities/Plunger/Plunger.tscn")
var plunger_attached : CharacterBody3D
var plunger_detached : CharacterBody3D

func _ready():
	# Add the Plunger to Level3D. This version of the Plunger has been shot out of the gun
	plunger_detached = plunger_scene.instantiate()
	plunger_detached.global_position = global_position
	get_tree().get_root().add_child(plunger_detached)
	
	# This Plunger is directly attached to the gun so it will have all the same animations
	


func _input(event):
	#if event is InputEventKey:
	#	if Input.is_action_pressed("shoot"):
	#		var plunger 
	pass		

func _process(delta):
	pass
