extends CharacterBody3D

signal cow_hit(cow)

@onready var stick_end : Node3D = $StickEnd
var speed : float = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = 9.8 #ProjectSettings.get_setting("physics/3d/default_gravity")

var direction : Vector3 = Vector3.ZERO
var previous_position : Vector3 = Vector3.ZERO

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	#else:
	#	velocity = Vector3.ZERO
	
	# Travel in direction
	#velocity = direction * speed
	
	# Move object
	move_and_slide()

func _apply_force(direction, speed):
	velocity = direction * speed

func _on_area_3d_body_entered(body):
	#emit_signal("cow_hit", body)
	pass


func _on_area_3d_area_entered(area):
	if area.get_parent().is_in_group("cows"):
		emit_signal("cow_hit", area.get_parent())
