extends Buyable

var player;

func _ready():
    super()
    player = get_node("/root/Level3D/PLAYER")
    pass

func add_effect():
    player.jump_strength += 10
    print("added jump strength")
