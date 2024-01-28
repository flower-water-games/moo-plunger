extends Buyable

var plunger_gun : PlungerGun
func _ready():
	super()
	for child in get_tree().current_scene.get_children():
		if child is Player:
			plunger_gun = child.plunger
	#plunger_gun = get_node("/root/Level3D/PLAYER/Head/Camera3D/PlungerGun") as PlungerGun

func add_effect():
	plunger_gun.launch_speed += 20
