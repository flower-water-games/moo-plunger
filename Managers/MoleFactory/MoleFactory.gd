extends Node

@export var spawn_area : CollisionShape3D
@export var cow_group : Node3D

var mole_scene = load("res://Entities/Mole/Mole.tscn")
var total_moles_spawned : int = 0

var mole_time_to_spawn : float = 3.0

func _ready():
	# Spawn a random mole after X period of time
	_delay_between_spawn()

func _delay_between_spawn():
	get_tree().create_timer(randf_range(mole_time_to_spawn-1, mole_time_to_spawn+1)).timeout.connect(_spawn_mole)
	
func _spawn_mole():
	var mole = mole_scene.instantiate()
	get_tree().current_scene.add_child(mole)
	
	# Provide the cow group from Level3D
	mole.cow_group = cow_group
	
	var padding = 0.5
	var random_x = randf_range(padding, spawn_area.shape.size.x - padding)
	var random_z = randf_range(padding, spawn_area.shape.size.z - padding)
	var initial_height_from_ground : float = 2.0
	var offset = spawn_area.shape.size * 0.5
	mole.position = spawn_area.global_position - offset + Vector3(random_x, initial_height_from_ground, random_z)
	
	total_moles_spawned += 1
	print("Mole spawned. Total spawned " + str(total_moles_spawned))
	
	# Create another Mole
	_delay_between_spawn()
