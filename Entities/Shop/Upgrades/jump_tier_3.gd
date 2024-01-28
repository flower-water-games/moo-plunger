extends Buyable

var player;

func _ready():
	super()
	for child in get_tree().current_scene.get_children():
		if child is Player:
			player = child

func add_effect():
	player.jump_strength += 8
	print("added jump strength")
