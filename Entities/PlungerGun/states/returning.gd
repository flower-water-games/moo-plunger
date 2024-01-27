extends State

@export var gun_ready : State

func process_input(event: InputEvent) -> State:
    return null

func enter() -> void:
    parent.get_node("LaunchSound").stop()

func process_physics(delta: float) -> State:
    parent.velocity.y += gravity * delta
    var movement = Input.get_axis('move_left', 'move_right') * move_speed
    parent.animations.flip_h = movement < 0
    parent.velocity.x = movement
    parent.move_and_slide()
    return gun_ready