extends CharacterBody3D

# this class represents a cow that has an AnimationPlayer we can use to play animations
# basic loop, is randomly on an interval, the cow determines if it is picked to "float"
# if it is, it will play the inflate animation, and the node3d needs to slowly accelerate up into the air
# if theres a collision with the player's raycast3d, the cow will play the deflate animation and fall back down

class_name Cow

signal cow_inflated
# signal cow_dead

var air_inflation : float = 0.0
var air_max_inflation : float = 100.0

var floating = false
var gravity = -9.8

var min_float_speed = .1
var float_speed = 1.0
var last_float_time = 0.0
var float_interval = 6.0

var cow_speed = .3

var float_rotation_max : float = 0.005
var z_float_rotation_speed : float = 0.0
var y_float_rotation_speed : float = 0.0
var x_float_rotation_speed : float = 0.0

#node child under this called "Collider"

@onready var cow_armature = $Armature

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var cow_physics_collider = $PhysicsCollider
@onready var cow_body_collider = $InflatedArea3D/Collider


var cow_default_size = Vector3(2.0, 2.5, 2.5)

func _ready():
	# Make the collision shape unique to the cow
	cow_body_collider.shape = cow_body_collider.shape.duplicate()
	cow_physics_collider.shape = cow_physics_collider.shape.duplicate()
	cow_physics_collider.shape.size = cow_default_size
	
	# Set up randomized rotation floating
	x_float_rotation_speed = randf_range(-float_rotation_max, float_rotation_max)
	z_float_rotation_speed = randf_range(-float_rotation_max, float_rotation_max)
	y_float_rotation_speed = randf_range(-float_rotation_max, float_rotation_max)
	
	# Rotate the cow randomly
	rotation.y = deg_to_rad(randf_range(0.0, 360.0))

func wait_arbitrary_amount_of_time_before_floating():
	get_tree().create_timer(randf_range(1.0, 10.0)).timeout.connect(_try_to_float)

func _physics_process(delta):
	if floating:
		rotate_inflated_cow()
		# Cap speed increase
		if velocity.y < float_speed:
			velocity.y += float_speed * delta
	else:
		velocity.y += gravity * delta # Apply gravity
	
	# Apply friction on the ground
	if is_on_floor():
		velocity.z *= 0.8
		velocity.x *= 0.8

	
	var collision_info = move_and_collide(velocity, true)
	# Object collided
	if collision_info:
		# Bounce off Cows
		var hit_object = collision_info.get_collider()
		if hit_object is Cow or hit_object is Player:
			var speed_vector = global_position.direction_to(hit_object.position).normalized() #velocity.bounce(collision_info.get_normal()) * 0.5
			velocity.x -= speed_vector.x
			velocity.z -= speed_vector.z
	
	# Snapping
	move_and_slide()

	# Is it out of bounds?
	if position.y > 80:
		# vibes
		# call signal 
		Main.emit_signal("cow_dead")
		print('emit signal dead cow')
		queue_free()
		
	# Inflating the cow
	if air_inflation >= air_max_inflation:
		air_inflation = air_max_inflation
		_try_to_float()
		$cow_inflate.play()

func _try_to_float():
	if is_on_floor():
		start_floating()
		$cow_moo.play()

func start_floating():
	floating = true
	animation_player.play("Inflate")
	# Cow has inflated
	emit_signal("cow_inflated")
	# Reset collision shapes
	cow_body_collider.shape.radius = 2.0
	cow_physics_collider.shape.size = Vector3(2.5, 4.0, 2.5)

func stop_floating():
	floating = false
	animation_player.play("De-inflate")
	# Reset collision shapes
	cow_body_collider.shape.radius = 1.1
	cow_physics_collider.shape.size = cow_default_size
	# Reset rotation
	cow_armature.rotation = Vector3(deg_to_rad(90.0), 0, 0)
	# Reset the air
	air_inflation = 0.0

func rotate_inflated_cow():
	cow_armature.rotation.x -= x_float_rotation_speed
	cow_armature.rotation.y += y_float_rotation_speed
	cow_armature.rotation.z += z_float_rotation_speed
