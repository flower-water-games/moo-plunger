extends State

@export
var gun_ready: State
@export
var retrieving: State
@export
var returning: State

# shooting forward means the plunger is currently in the air
# and the player is waiting for it to return, or can return it with input

# transitions are as follows:
# shooting forward -> retrieving (on collision)
# shooting forward -> returning


func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed('return'):
		return retrieving
	return null

func enter() -> void:
	parent.get_node("LaunchSound").play()


func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	
	parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	return retrieving
	