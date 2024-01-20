extends Node3D

var plunger_scene = load("res://Entities/Plunger/Plunger.tscn")

@onready var gun_plunger : CharacterBody3D = $Plunger
var world_plunger : CharacterBody3D

var action_shoot : bool = false
var action_stuck : bool = false
var action_retrieve : bool = false

var max_distance_from_player : int = 30

func _ready():
	# Add the Plunger to Level3D. This version of the Plunger has been shot out of the gun
	world_plunger = plunger_scene.instantiate()
	world_plunger.global_position = gun_plunger.global_position
	get_tree().get_root().add_child(world_plunger)
	
	# This Plunger is directly attached to the gun so it will have all the same animations


func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("shoot"):
			_shoot_plunger()

func _shoot_plunger():
	pass

func _process(delta):
	pass
