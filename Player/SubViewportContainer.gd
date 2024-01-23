extends SubViewportContainer

@onready var subviewport : SubViewport = $SubViewport
@onready var gun_camera : Camera3D = $SubViewport/GunCamera3D
@export var player_camera : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Resize viewport to fit the players monitor size
	get_tree().get_root().size_changed.connect(_on_size_changed)
	_on_size_changed()
	set_process(false) # Turned this off for now

func _process(_delta):
	# Match the GUN CAMERA to the PLAYER CAMERA
	# This camera only renders the gun. Which prevents it from clipping into objects in the scene
	gun_camera.global_transform = player_camera.global_transform

func _on_size_changed():
	size = get_viewport().size
	subviewport.size = get_viewport().size
