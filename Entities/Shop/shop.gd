extends Node3D

# list of packedscenes to be instanced at shop_refresh()

class_name Shop

@export var all_upgrades : Array[PackedScene]

var is_shop_available : bool = false

# timer where shop will move in or move out
@onready var shop_timer : Timer = $Timer
@onready var label : Label3D = $Label3D

var initial_position : Vector3
var away_position : Vector3
var upgrade_purchased_states: Dictionary = {}

func _ready():
    initial_position = global_transform.origin
    away_position = Vector3(initial_position.x, initial_position.y, -20)
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

        global_transform.origin = initial_position
        is_shop_available = true
        print("shop is available")

func refresh_shop():
    # choose 3 random upgrades that hasn't already been purchased
    # and instance them, then place them on top of the shelf
    # and add them to the scene tree
    var chosen_upgrades : Array[PackedScene] = choose_three_random_upgrades()

    # if there are no more upgrades to be purchased, then
    # the shop will be closed
    pass


func choose_three_random_upgrades():


    pass
    # choose 3 random upgrades that hasn't already been purchased
    # and instance them, then place them on top of the shelf
    # and add them to the scene tree

    # if there are no more upgrades to be purchased, then
    # the shop will be closed
