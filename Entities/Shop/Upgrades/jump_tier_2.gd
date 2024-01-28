extends Buyable

var player;

func _ready():
	super()
	for child in get_tree().current_scene.get_children():
		if child is Player:
			player = child
			break

func add_effect():
	player.jump_strength += 5 
	print("added jump strength")
