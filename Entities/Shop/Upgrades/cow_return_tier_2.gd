extends Buyable

var plunger_gun : PlungerGun
func _ready():
    super()
    plunger_gun = get_node("/root/Level3D/PLAYER/Head/Camera3D/PlungerGun") as PlungerGun

func add_effect():
    plunger_gun.cow_return_speed += 20
