extends Node3D

class_name Buyable

@export_subgroup("Properties")
@export var item_name = "Buyable"
@export var cost = 5

var farm_manager

func _ready():
    farm_manager = get_node("/root/Level3D/FarmManager") as FarmManager
    pass

# abstract function for sublcasses to implement
func add_effect():
    pass

func buy():
    if farm_manager.player_currency >= cost:
        farm_manager.player_currency -= cost
        add_effect()
        print("Bought " + item_name + " for " + str(cost) + " currency")
        queue_free()
    else:
        print("Not enough money!")