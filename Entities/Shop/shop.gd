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
	away_position = Vector3(-80,  initial_position.y, initial_position.z)
	global_transform.origin = away_position
	shop_timer.connect("timeout", switch_shop)
	switch_shop()
	$Audio_Train.play()

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
		#global_transform.origin = away_position
		# Remove the items
		var children = shelf.get_children()
		for child in children:
			child.item.queue_free()
		is_shop_available = false
		print("shop is closed")
	else:
		# refresh shop here
		refresh_shop()
		global_transform.origin = initial_position
		is_shop_available = true
		print("shop is available")
		$Audio_Train.play()

func refresh_shop():
	# remove all children from shelf
	var children = shelf.get_children()
	for child in children:
		child.queue_free()

	var chosen = choose_three_random_upgrades()
	instantiate_upgrade(chosen[0], 0)
	instantiate_upgrade(chosen[1], 1)
	instantiate_upgrade(chosen[2], 2)
	# choose 3 random upgrades that hasn't already been purchased
	# and instance them, then place them on top of the shelf
	# and add them to the scene tree

	# if there are no more upgrades to be purchased, then
	# the shop will be closed
	pass


func choose_three_random_upgrades():
	# look through all upgrades and choose 3 that hasn't been purchased
	# and return them in an array
	var unpurchased_upgrades = []
	for upgrade in all_upgrades:
		var instance = upgrade.instantiate() as Buyable
		register_in_shop(instance.item_name)
		if upgrade_purchased_states[instance.item_name] == 0:
			unpurchased_upgrades.append(upgrade)
	
	if unpurchased_upgrades.size() < 3:
		print("Not enough unpurchased upgrades available")
		return []

	var chosen_upgrades = []
	for i in range(3):
		var random_index = randi() % unpurchased_upgrades.size()
		chosen_upgrades.append(unpurchased_upgrades[random_index])
		unpurchased_upgrades.pop_at(random_index)

	return chosen_upgrades

	

var distance_per_slot = 5.2

# slot_num should be 0, 1, or 2
func instantiate_upgrade(upgrade: PackedScene, slot_num):
	var instance := upgrade.instantiate() as Buyable
	register_in_shop(instance.item_name)
	if upgrade_purchased_states[instance.item_name] == 1:
		instance.queue_free()
		return false
	shelf.add_child(instance)
	# based on slot_num = 0, 1, or 2, map to 0, distance_per_slot, or 2*distance_per_slot
	instance.transform.origin = Vector3(slot_num*distance_per_slot, 0, 0)
	return true
	# choose 3 random upgrades that hasn't already been purchased
	# and instance them, then place them on top of the shelf
	# and add them to the scene tree

	# if there are no more upgrades to be purchased, then
	# the shop will be closed
