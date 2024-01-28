extends Node

@export var spawn_area : CollisionShape3D
@export var cow_group : Node3D

var mole_scene = load("res://Entities/Mole/Mole.tscn")
var total_moles_spawned : int = 0

var mole_time_to_spawn : float = 3.0

# Moles get faster
var mole_inflate_speed_increment : float = 0.05
var mole_inflate_speed : float = 0.1

var mole_count : int = 0

func _ready():
	# Spawn a random mole after X period of time
	_delay_between_spawn()

func _delay_between_spawn():	
	mole_count += 1
	if mole_count > 15:
		mole_time_to_spawn = 2.0
	if mole_count > 40:
		mole_time_to_spawn = 1.6
	get_tree().create_timer(randf_range(mole_time_to_spawn-1.0, mole_time_to_spawn+1.0)).timeout.connect(_spawn_mole)
	
func _spawn_mole():
	# Count how many moles exist in the level
	var moles_in_level : int = 0
	for child in get_tree().current_scene.get_children():
		if child is Mole:
			moles_in_level += 1
	
	# Cap the number of moles at a time
	var max_moles_at_a_time : int  = 16
	if moles_in_level > max_moles_at_a_time:
		_delay_between_spawn()
		return
			
	var mole = mole_scene.instantiate()
	get_tree().current_scene.add_child(mole)
	
	# Provide the cow group from Level3D
	mole.cow_group = cow_group
	
	# Increase the speed over time
	mole_inflate_speed += mole_inflate_speed_increment
	mole.air_inflation_speed = mole_inflate_speed
	
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
