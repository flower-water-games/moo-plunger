extends Node3D

# represents the farm and tracks how many cows are inside
# has an Area 3D node child
# which has a CollisionShape3D child

class_name FarmManager

@onready var farm_collider = $Area3D
@onready var bonus_timer : Timer = $BonusTimer

var cost_per_cow = 10.0
var player_UI : Label

func _ready():
	player_UI = get_node("/root/Level3D/PLAYER/PlayerUI/Label")
	# in godot 4 set the timer to call add_cow_bonus
	#bonus_timer.connect("timeout", add_cow_bonus)



var cows_inside = 0

var player_currency = 0

func add_currency(amount):
	player_currency += amount
	player_UI.text = make_status_string()

func add_cow_bonus():
	player_currency += cows_inside * cost_per_cow
	player_UI.text = "you got a bonus!\n" + make_status_string()

func _on_area_3d_body_entered(body:Node3D):
	if body.is_in_group("cows"):
		cows_inside += 1
		player_UI.text = "cow in!\n" + make_status_string()
		print('gained a cow')

func _on_area_3d_body_exited(body:Node3D):
	if body.is_in_group("cows"):
		cows_inside -= 1
		print('lost a cow')
		player_UI.text = "oh no cow loose!\n" + make_status_string()

func make_status_string():
	return "you have " + str(cows_inside) + " cows" + "\n" + "you have " + str(player_currency) + " moles"
