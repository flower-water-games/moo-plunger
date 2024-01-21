extends RayCast3D

# when raycast collides with an area3d, trigger that node's animation player toa new animation


# this is used to trigger the animation of the door opening when the player is close enough to the door
# this is also used to trigger the animation of the door closing when the player is far enough from the door



func _physics_process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider is Area3D:
			var animation_player = collider.get_node("../AnimationPlayer") # replace with the path to your AnimationPlayer node
			if animation_player:
				animation_player.play("Inflate") # replace with the name of your animation
