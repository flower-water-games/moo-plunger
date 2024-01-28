extends CharacterBody3D

class_name Mole

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Store the available cows
var cow_group : Node3D
var my_cow = null

@onready var mole_armature : Node3D = $GGJ_Mole_Animated3/Armature
@onready var animator : AnimationPlayer = $GGJ_Mole_Animated3/AnimationPlayer
var is_being_retrieved = false
enum State {PICKING, SEEKING_UNDERGROUND, INFLATING, DYING}

var mole_state : State = State.PICKING

var shrink_mole_hill : bool = false
var air_inflation_speed : float = 0.1

func _ready():
	print("Mole Spawned!")
	call_deferred("_pick_a_cow")
	get_tree().create_timer(15.0).timeout.connect(_check_if_stuck)
	# Invisible before you land on the ground
	visible = false
	# Delete mole if it spawns inside an object
	var collision_info = move_and_collide(Vector3(0,0,0), true)
	if not collision_info == null:
		print("Spawned in wall")
		queue_free()

func _check_if_stuck():
	# If it still hasn't reached the cow it probably got stuck somewhere, so lets just kill it
	if not mole_state == State.INFLATING:
		shrink_mole_hill = true
		get_tree().create_timer(5.0).timeout.connect(_destroy_mole)

func _pick_a_cow():
	mole_state = State.PICKING
	var grounded_cow_list : Array = []
	for cow in cow_group.get_children():
		# Add cows that are on the floor
		if cow.is_on_floor():
			grounded_cow_list.append(cow)
		
	if grounded_cow_list.size() > 0:
		# Randomize the order of the cows
		grounded_cow_list.shuffle()
		# Pick the first cow in the shuffled deck
		my_cow = grounded_cow_list[0]
		# Connect to the cow
		my_cow.cow_inflated.connect(_cow_has_inflated)
		mole_state = State.SEEKING_UNDERGROUND
		
		# Rotate node A to look at node B with the given up vector
		look_at(my_cow.global_transform.origin, Vector3(0, 1, 0))
		# Reset the x, y rotation
		rotation.x = 0.0
		rotation.z = 0.0
		# Flip around 180 because the Mole is facing backwards
		rotation.y += deg_to_rad(180) 
		
	else:
		# Search for another cow after a X second delay
		get_tree().create_timer(2.0).timeout.connect(_pick_a_cow)

func _cow_has_inflated():
	# Destroy mole after 5 seconds
	get_tree().create_timer(5.0).timeout.connect(_destroy_mole)
	my_cow == null
	animator.play("Back_underground")

func _destroy_mole():
	queue_free()

func _inflate_the_cow():
	if not my_cow == null:
		my_cow.air_inflation += air_inflation_speed
		mole_state = State.INFLATING

var pop_out_state = false

func _process(delta):
	if is_on_floor():
		visible = true
		
	match mole_state:
		State.PICKING:
			#print("Picking a cow")
			pass
		State.SEEKING_UNDERGROUND:
			#print("Seeking underground")
			pass
		State.INFLATING:
			if not pop_out_state:
				animator.play("Pop_out_Ground")
				pop_out_state = true

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Pop_out_Ground":
			animator.play("banging_pump_loop")
		"Back_underground":
			shrink_mole_hill = true

func _physics_process(delta):
	if is_being_retrieved:
		# velocity.x = 0
		# velocity.z = 0
		velocity.x = 0
		velocity.z = 0
		my_cow = null
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# if 
	if not my_cow == null:
		# Move towards cow
		if global_position.distance_to(my_cow.global_position) > 3.0:
			if my_cow.is_on_floor():
				var direction_to_cow = global_position.direction_to(my_cow.global_position)
				velocity.x = direction_to_cow.x * 10.0
				velocity.z = direction_to_cow.z * 10.0

		else:
			# Slow down moles
			velocity.x *= 0.8
			velocity.z *= 0.8
			# Inflate the cow
			_inflate_the_cow()
			
	# Move the mole
	move_and_slide()
	
	# out of bounds
	if position.y < -40.0:
		print("Mole out of bounds")
		queue_free()

	if shrink_mole_hill:
		if mole_armature.scale.y > 0.1:
			mole_armature.scale *= 0.8
