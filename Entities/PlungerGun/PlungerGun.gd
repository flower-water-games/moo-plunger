extends Node3D

var plunger_scene = preload("res://Entities/Plunger/Plunger.tscn")
#var Cow = preload("res://Objects/cow.gd")

@export_subgroup("Properties")
@export var launch_speed : float = 10.0
@export var return_speed : float = 10.0
@export var max_distance_from_player : int = 30


@onready var plunger_end : Node3D = $PlungerEnd
@onready var rope : CSGBox3D = $Rope
var world_plunger : CharacterBody3D
var current_cow : CharacterBody3D

enum State {SHOOTING, STUCK, RETURNING, DEFAULT}
var plunger_state = State.DEFAULT


func _ready():
	# Add the Plunger to Level3D (Not a child of the Player)
	world_plunger = plunger_scene.instantiate()
	world_plunger.global_transform = plunger_end.global_transform
	get_tree().get_root().add_child(world_plunger)
	world_plunger.connect("cow_hit", cow_hit)

func _shoot_plunger():
	if plunger_state == State.DEFAULT:
		plunger_state = State.SHOOTING
		world_plunger.speed = launch_speed
		world_plunger.direction = global_position.direction_to(plunger_end.global_position)
		print("Fire!")

func _return_plunger():
	plunger_state = State.RETURNING
	world_plunger.speed = return_speed
	world_plunger.direction = world_plunger.global_position.direction_to(plunger_end.global_position)
	print("Return!")

func _input(event:InputEvent):
	# Shooting
	if Input.is_action_pressed("shoot"):
		_shoot_plunger()

func cow_hit(body):
	current_cow = body
	current_cow.velocity = Vector3.ZERO
	current_cow.stop_floating()
	# current_cow.speed = return_speed 
	plunger_state = State.STUCK


func _physics_process(delta):
		
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

			if world_plunger.global_position.distance_to(plunger_end.global_position) > max_distance_from_player:
				_return_plunger()
		State.STUCK: 
			world_plunger.direction = world_plunger.global_position.direction_to(plunger_end.global_position)
			# calculate new current_cow's velocity vector based on making sure the cow is facing the plunger_end
			current_cow.velocity = current_cow.global_position.direction_to(plunger_end.global_position) * return_speed


			#current_cow.direction = world_plunger.global_position.direction_to(plunger_end.global_position)
			#Rotate it towards the barrel of the gun
			#_angle_plunger_towards_gun(delta)
			# Flip plunger around
			#world_plunger.scale = Vector3(1, 1, -1)
			# Return it to the player
			if world_plunger.global_position.distance_to(plunger_end.global_position) < 1:
				plunger_state = State.DEFAULT
				current_cow.queue_free()
				current_cow = null

		State.RETURNING: 
			world_plunger.direction = world_plunger.global_position.direction_to(plunger_end.global_position)
			#Rotate it towards the barrel of the gun
			_angle_plunger_towards_gun(delta)
			# Flip plunger around
			world_plunger.scale = Vector3(1, 1, -1)
			# Return it to the player
			if world_plunger.global_position.distance_to(plunger_end.global_position) < 1:
				plunger_state = State.DEFAULT
				world_plunger.global_transform = plunger_end.global_transform

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
	#var direction = (target_position_b - target_position_a).normalized()
	# if distance is more than one, then stretch the rope
	if distance > 1:
		rope.size.z = distance
		# Rotate the rope to align with the direction vector using the look_at method and the up vector
		rope.look_at(target_position_b, Vector3.UP)
		# Position the rope at the midpoint between the two points using the lerp method
		rope.global_transform.origin = target_position_a.lerp(target_position_b, 0.5)

	# Stretch the rope along the x-axis to match the distance
	
