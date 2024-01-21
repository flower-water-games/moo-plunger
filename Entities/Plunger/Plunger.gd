extends CharacterBody3D


var speed : float = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = 0.0 #ProjectSettings.get_setting("physics/3d/default_gravity")

var direction : Vector3 = Vector3.ZERO

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Travel in direction
	velocity = direction * speed
	print(velocity)
	
	# Move object
	move_and_slide()

