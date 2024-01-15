# extends Node2D # Change this

# @export var event: EventAsset
# var instance: EventInstance

# # Setting up the Audio banks -- https://alessandrofama.com/tutorials/fmod/godot/banks
# # Playing FMOD in game -- https://alessandrofama.com/tutorials/fmod/godot/events

# # Example of how to play FMOD
# func _ready():
# 	# Create FMOD
# 	instance = FMODRuntime.create_instance(event)
# 	# Start the song
# 	instance.start()
# 	# Release FMOD from memory to prevent memory leaks
# 	instance.release()

# func _update_parameters():
# 	var value : int = 0
# 	instance.set_parameter_by_name("parameter name", value, false) # Matching capitalization of the parameter name matters

# func _stop_FMOD():
# 	instance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
