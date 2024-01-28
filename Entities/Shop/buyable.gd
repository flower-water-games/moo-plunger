extends Node3D

class_name Buyable

@export_subgroup("Properties")
@export var item_name = "Buyable"
@export var cost = 5


@onready var label :Label3D = $Label3D

@onready var item : MeshInstance3D = $MeshInstance3D

var farm_manager : FarmManager
var shop : Shop

func _ready():
	var level = get_tree().current_scene
	
	for child in level.get_children():
		if child is FarmManager:
			farm_manager = child as FarmManager
			break
	
	for child in level.get_children():
		if child is Shop:
			shop = child as Shop
			break
	
	shop.register_in_shop(item_name)
	label.text = item_name + "\n" + str(cost) + " currency"

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
