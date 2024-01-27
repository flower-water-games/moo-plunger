extends Node3D

class_name Buyable

@export_subgroup("Properties")
@export var item_name = "Buyable"
@export var cost = 5


@onready var label :Label3D = $Label3D

var farm_manager : FarmManager
var shop : Shop

func _ready():
	farm_manager = get_node("/root/Level3D/FarmManager") as FarmManager
	shop = get_node("/root/Level3D/Shop") as Shop
	shop.register_in_shop(item_name)
	label.text = item_name + "\n" + str(cost) + " currency"
	pass

# abstract function for sublcasses to implement
func add_effect():
	pass

signal bought(name)

func buy():
	if farm_manager.player_currency >= cost:
		farm_manager.player_currency -= cost
		shop.purchase_item(item_name)
		add_effect()
		print("Bought " + item_name + " for " + str(cost) + " currency")
		queue_free()
	else:
		print("Not enough money!")
