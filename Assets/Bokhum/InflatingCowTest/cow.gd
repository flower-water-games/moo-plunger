extends Node3D

# on ready, get animation player node named "AnimationPlayer" and start animation on loop "Idle_Good"
# save animationplayer as a variable so we can use it later
@onready var CowAnimationPlayer : AnimationPlayer = get_node("AnimationPlayer")

#func _ready():
#CowAnimationPlayer.play("Idle_Good")