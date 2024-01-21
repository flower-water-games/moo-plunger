extends CharacterBody3D

# this class represents a cow that has an AnimationPlayer we can use to play animations
# basic loop, is randomly on an interval, the cow determines if it is picked to "float"
# if it is, it will play the inflate animation, and the node3d needs to slowly accelerate up into the air
# if theres a collision with the player's raycast3d, the cow will play the deflate animation and fall back down

class_name Cow

var floating = false
var gravity = -9.8
var float_speed = 1.0
var last_float_time = 0.0
var float_interval = 3.0

#node child under this called "Collider"

@onready var cow_collider = $Collider
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	if floating:
		velocity.y += float_speed * delta
	else:
		velocity.y += gravity * delta

	move_and_slide()

	last_float_time += delta
	last_float_time	-= randf_range(-.5, .5)
	if is_on_floor() and (delta + last_float_time) > float_interval:
		last_float_time = 0.0
		if not floating:
			pick_random_animation()
		
	# Is it out of bounds?
	out_of_bounds()

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

# if this body collides with a plunger gameobject collider, do something

func rotate_tween():
	var tween = create_tween()
	var end_rotation = rotation + Vector3(0, 0, PI/4) + Vector3(randf_range(-PI, PI), randf_range(-PI, PI), randf_range(-PI, PI)) # replace with the desired rotation
	var duration = randf_range(8, 15.0) # replace with the desired duration
	tween.tween_property(self, "rotation", end_rotation, duration)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.play()

# func _on_PlayerRayCast3D_body_entered(body):
#     if body == self:
#         stop_floating()
