extends Node3D

var plunger_scene = load("res://Entities/Plunger/Plunger.tscn")
#var Cow = preload("res://Objects/cow.gd")
var current_cow : Cow = null

@export_subgroup("Properties")
@export var launch_speed : float = 10.0
@export var return_speed : float = 10.0
@export var max_distance_from_player : int = 30


@onready var plunger_end : Node3D = $PlungerEnd
@onready var rope : CSGBox3D = $Rope
var world_plunger : CharacterBody3D

enum State {SHOOTING, STUCK, RETURNING, DEFAULT}
var plunger_state = State.DEFAULT


func _ready():
	# Add the Plunger to Level3D (Not a child of the Player)
	world_plunger = plunger_scene.instantiate()
	world_plunger.global_transform = plunger_end.global_transform
	get_tree().get_root().add_child(world_plunger)

func _shoot_plunger():
	if plunger_state == State.DEFAULT:
		plunger_state = State.SHOOTING
		world_plunger.speed = launch_speed
		world_plunger.direction = global_position.direction_to(plunger_end.global_position)
		print("Fire!")

func _return_plunger():
	if plunger_state == State.SHOOTING:
		plunger_state = State.RETURNING
		world_plunger.speed = return_speed
		world_plunger.direction = world_plunger.global_position.direction_to(plunger_end.global_position)
		print("Return!")

func _process(delta):
	# Shooting
	if Input.is_action_pressed("shoot"):
		_shoot_plunger()
		
	# State management
	match plunger_state:
		State.DEFAULT:
			world_plunger.global_transform = plunger_end.global_transform
      world_plunger.scale = Vector3(1, 1, 1) # Reset scale
		State.SHOOTING:
			# if the plunger collides with a collider that is the type cow
			# then set the plunger to stuck
	
			# world_plunger has a CollisionShape3D node as a child
			# if the plunger is colliding with something

			var collision_shape : CollisionShape3D = world_plunger.get_node("CollisionShape3D")
			var space_state = PhysicsServer3D.space_get_direct_state(get_world_3d().space)

			var shape_query = PhysicsShapeQueryParameters3D.new()
			shape_query.shape_rid = collision_shape.shape
			shape_query.transform = world_plunger.global_transform

			var result = space_state.intersect_shape(shape_query, 1)
			if result and result.size() > 0:
				var collider = result[0]["collider"]
				print("colliding")
				# collider's parent is the Cow
				# get the parent of the collider
				# check if the collider's parent has the cow.gd script
				if collider.get_parent() is Cow:
					print("Cow!")
					current_cow = collider
					current_cow.speed = return_speed
					world_plunger.speed = return_speed
					world_plunger.direction = world_plunger.global_position.direction_to(plunger_end.global_position)
					plunger_state = State.STUCK
					world_plunger.speed = 0
					print("Stuck!")
				else:
					print("Not a cow!")
			if world_plunger.global_position.distance_to(plunger_end.global_position) > max_distance_from_player:
				_return_plunger()

		State.RETURNING or State.STUCK:
			world_plunger.direction = world_plunger.global_position.direction_to(plunger_end.global_position)
			if (plunger_state == State.STUCK):
				current_cow.direction = current_cow.global_position.direction_to(plunger_end.global_position)
			# Rotate it towards the barrel of the gun
			_angle_plunger_towards_gun(delta)
			# Flip plunger around
			world_plunger.scale = Vector3(1, 1, -1)
			# Return it to the player
			if world_plunger.global_position.distance_to(plunger_end.global_position) < 1:
				if (plunger_state == State.STUCK):
					current_cow = null
					# kill the cow for now
					current_cow.queue_free()
					print("Cow is free!")
				plunger_state = State.DEFAULT
	
	# Rope
	_rope_stretch(plunger_end.global_position, world_plunger.stick_end.global_position)

func _angle_plunger_towards_gun(delta):
	# Point the plunger towards the gun
	var speed = 10 # The rotation speed
	var target_position = plunger_end.global_position # The origin
	var up_vector = Vector3.UP # The positive Y axis
	var new_transform = world_plunger.transform.looking_at(target_position, up_vector) # The desired transform
	# The interpolated transform
	world_plunger.transform = world_plunger.transform.interpolate_with(new_transform, speed * delta)

func _rope_stretch(target_position_a, target_position_b):
	# Calculate the distance and direction between the two points
	var distance = target_position_a.distance_to(target_position_b)
	var direction = (target_position_b - target_position_a).normalized()
	# Stretch the rope along the x-axis to match the distance
	rope.size.z = distance
	# Rotate the rope to align with the direction vector using the look_at method and the up vector
	rope.look_at(target_position_b, Vector3.UP)
	# Position the rope at the midpoint between the two points using the lerp method
	rope.global_transform.origin = target_position_a.lerp(target_position_b, 0.5)
