extends Node3D

# represents the farm and tracks how many cows are inside
# has an Area 3D node child
# which has a CollisionShape3D child

@onready var farm_collider = $Area3D
var player_UI : Label
func _ready():
	player_UI = get_node("/root/Level3D/PLAYER/PlayerUI/Label")

var cows_inside = 0

func _on_area_3d_body_entered(body:Node3D):
	if body.is_in_group("cows"):
		cows_inside += 1
		player_UI.text = "you have " + str(cows_inside) + " cows"
		print('gained a cow')

func _on_area_3d_body_exited(body:Node3D):
	if body.is_in_group("cows"):
		cows_inside -= 1
		print('lost a cow')
		player_UI.text = "you have " + str(cows_inside) + " cows"
