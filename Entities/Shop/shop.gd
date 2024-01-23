extends Node3D

# list of packedscenes to be instanced at shop_refresh()

class_name Shop

@export var all_upgrades : Array[PackedScene]

var is_shop_available : bool = false

# timer where shop will move in or move out
@onready var shop_timer : Timer = $Timer
@onready var label : Label3D = $Label3D
@onready var shelf : Node3D = $Shelf

var initial_position : Vector3
var away_position : Vector3
var upgrade_purchased_states: Dictionary = {}

func _ready():
	initial_position = global_transform.origin
	away_position = Vector3(initial_position.x, initial_position.y, -80)
	global_transform.origin = away_position
	shop_timer.connect("timeout", switch_shop)

	# for each scene in all_upgrades
	# add to a dictionary of each scene with its name as the key
	


	# and a 0 or a 1 as its value to show if it has been purchased or not
	# 0 = not purchased, 1 = purchased

func register_in_shop(item_name: String):
	if (upgrade_purchased_states.has(item_name)):
		print("upgrade already registered")
		return
	upgrade_purchased_states[item_name] = 0


func purchase_item(item_name: String):
	if (upgrade_purchased_states.has(item_name)):
		if (upgrade_purchased_states[item_name] == 1):
			print("item already purchased")
			return
		upgrade_purchased_states[item_name] = 1
		print("purchased " + item_name)
	else:
		print("item not found")

func _process(delta):
	update_label()

func update_label():
	# round time left to whole seconds
	label.text = str(round(shop_timer.time_left)) + " seconds left!"

func switch_shop():
	if is_shop_available:
		global_transform.origin = away_position
		is_shop_available = false
		print("shop is closed")
	else:
		# refresh shop here
		refresh_shop()
		global_transform.origin = initial_position
		is_shop_available = true
		print("shop is available")

func refresh_shop():
	# remove all children from shelf
	var children = shelf.get_children()
	for child in children:
		child.queue_free()
	instantiate_upgrade(all_upgrades[0], 0)
	instantiate_upgrade(all_upgrades[1], 2)
	# choose 3 random upgrades that hasn't already been purchased
	# and instance them, then place them on top of the shelf
	# and add them to the scene tree

	# if there are no more upgrades to be purchased, then
	# the shop will be closed
	pass


func choose_three_random_upgrades():


	pass


# slot_num should be 0, 1, or 2
func instantiate_upgrade(upgrade: PackedScene, slot_num):
	var instance := upgrade.instantiate() as Buyable
	register_in_shop(instance.item_name)
	if upgrade_purchased_states[instance.item_name] == 1:
		instance.queue_free()
		return false
	shelf.add_child(instance)
	instance.transform.origin = Vector3(slot_num-1.7, 1, 0)
	return true
	# choose 3 random upgrades that hasn't already been purchased
	# and instance them, then place them on top of the shelf
	# and add them to the scene tree

	# if there are no more upgrades to be purchased, then
	# the shop will be closed
