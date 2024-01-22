extends CharacterBody3D

# this class represents a cow that has an AnimationPlayer we can use to play animations
# basic loop, is randomly on an interval, the cow determines if it is picked to "float"
# if it is, it will play the inflate animation, and the node3d needs to slowly accelerate up into the air
# if theres a collision with the player's raycast3d, the cow will play the deflate animation and fall back down

class_name Cow

var floating = false
var gravity = -9.8

var min_float_speed = 0.1
var float_speed = 1.0
var last_float_time = 0.0
var float_interval = 6.0

var cow_speed = .3

var y_float_rotation_speed : float = 0.005
var x_float_rotation_speed : float = 0.005

#node child under this called "Collider"

@onready var cow_collider = $Collider
@onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready():
	y_float_rotation_speed = randf_range(-y_float_rotation_speed, y_float_rotation_speed)

func _physics_process(delta):
	if floating:
		rotate_cow()
		if velocity.y < float_speed:
			velocity.y += float_speed * delta
	else:
		# Gravity always applies
		velocity.y += gravity * delta

	

	move_and_slide()

	_choose_to_float(delta)

	# Is it out of bounds?
	out_of_bounds()


func _choose_to_float(delta):
	last_float_time += delta
	last_float_time	-= randf_range(-.5, .5)
	if is_on_floor() and (delta + last_float_time) > float_interval:
		last_float_time = 0.0
		if not floating:
			pick_random_animation()


func out_of_bounds():
	if position.y > 100:
		queue_free() # Remove Cow from scene

func pick_random_animation():
	if randf_range(0, 1) < 0.5:
		start_floating()
	# elif floating:
	# 	stop_floating()

func start_floating():
	floating = true
	animation_player.play("Inflate")
	cow_collider.scale = Vector3(2.0, 2.0, 2.0)


func stop_floating():
	floating = false
	animation_player.play("De-inflate")
	cow_collider.scale = Vector3(1.0, 1.0, 1.0)
	rotation = Vector3(0, 0, 0)
	current_tween.stop()
	current_tween = null

# if this body collides with a plunger gameobject collider, do something

var current_tween : Tween = null 

func rotate_cow():
	rotation.x -= x_float_rotation_speed
	rotation.y += y_float_rotation_speed
