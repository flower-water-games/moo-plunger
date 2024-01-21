extends Node3D

var plunger_scene = load("res://Entities/Plunger/Plunger.tscn")

@onready var plunger_end : Node3D = $PlungerEnd
var world_plunger : CharacterBody3D

enum State {SHOOT, STUCK, RETURN, DEFAULT}
var plunger_state = State.DEFAULT

var max_distance_from_player : int = 30

func _ready():
	# Add the Plunger to Level3D (Not a child of the Player)
	world_plunger = plunger_scene.instantiate()
	world_plunger.global_transform = plunger_end.global_transform
	get_tree().get_root().add_child(world_plunger)


func _shoot_plunger():
	if plunger_state == State.DEFAULT:
		plunger_state = State.SHOOT
		world_plunger.speed = 10.0
		world_plunger.direction = global_position.direction_to(plunger_end.global_position)
		print("Fire!")

func _process(delta):
	
	if Input.is_action_pressed("shoot"):
		_shoot_plunger()
		
	match plunger_state:
		State.DEFAULT:
			world_plunger.global_transform = plunger_end.global_transform
