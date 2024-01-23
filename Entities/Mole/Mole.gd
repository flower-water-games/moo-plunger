extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Store the available cows
var cow_group : Node3D
var my_cow = null

func _ready():
	print("Mole Spawned!")
	call_deferred("_pick_a_cow")

func _pick_a_cow():
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
		
	else:
		# Search for another cow after a X second delay
		get_tree().create_timer(2.0).timeout.connect(_pick_a_cow)

func _cow_has_inflated():
	# Destroy mole after 5 seconds
	get_tree().create_timer(3.0).timeout.connect(_destroy_mole)

func _destroy_mole():
	queue_free()

func _inflate_the_cow():
	if not my_cow == null:
		my_cow.air_inflation += 1.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if not my_cow == null:
		# Move towards cow
		if global_position.distance_to(my_cow.global_position) > 3.0:
			var direction_to_cow = global_position.direction_to(my_cow.global_position)
			velocity.x = direction_to_cow.x * 10.0
			velocity.z = direction_to_cow.z * 10.0
		else:
			# Slow down moles
			velocity.x *= 0.8
			velocity.z *= 0.8
			# Inflate the cow
			_inflate_the_cow()
	
	move_and_slide()
	
	if position.y < -40.0:
		print("Mole out of bounds")
		queue_free()