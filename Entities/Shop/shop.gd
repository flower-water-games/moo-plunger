extends Node3D

# list of packedscenes to be instanced at shop_refresh()

var all_upgrades : Array[PackedScene]

var is_shop_available : bool = false

# timer where shop will move in or move out
@onready var shop_timer : Timer = $Timer
@onready var label : Label3D = $Label3D

var initial_position 

func _ready():
    initial_position = global_transform.origin
    shop_timer.connect("timeout", switch_shop)

func _process(delta):
    update_label()

func update_label():
    label.text = str(shop_timer.time_left) + " seconds left"

func switch_shop():
    if is_shop_available:
        global_transform.origin = Vector3(initial_position.x,initial_position.y,-20)
        is_shop_available = false
        print("shop is not available")
    else:
        global_transform.origin = initial_position
        is_shop_available = true
        print("shop is available")
