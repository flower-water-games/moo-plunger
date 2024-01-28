extends Control

var name_and_titles : Array[Array] = [
	["Name", "Title"],
	["freshwater games", "frogGODs"],
	["Lyndon", "Developer, Artist"], 
	["AlexRC", "Developer, PM"], 
	["CM", "Developer"],
	["David Gibson McLean","Composer"],
	["Paul Barbato", "Design Generalist"],
	["Tyler Gonelli", "Sound design"],
	["Lori Kinney", "Animation and Audio Dev"],
	["cows", "moooo"],
	["Jesse Sheehan", "QA/Playtesting, Copywriting"],
	["Carlos Ochoa", "Concept Artist, 3D Artist, Illustrator"],
	["Alexander Harder", "Sound Design"],
	]



@onready var hsplit_container : HSplitContainer = $MarginContainer/HBoxContainer/HSplitContainer
@onready var label_name : Label = $MarginContainer/HBoxContainer/HSplitContainer/VBoxContainerName/Name
@onready var label_title : Label = $MarginContainer/HBoxContainer/HSplitContainer/VBoxContainerTitle/Title

@onready var vboxcontainer_name : VBoxContainer = $MarginContainer/HBoxContainer/HSplitContainer/VBoxContainerName
@onready var vboxcontainer_title : VBoxContainer = $MarginContainer/HBoxContainer/HSplitContainer/VBoxContainerTitle

@onready var button_container : CenterContainer = $CenterContainer
var margin_bottom : float = 48

func _ready():
	name_and_titles.shuffle()
	for i in range(name_and_titles.size()):
		if i > 0:
			var new_name = label_name.duplicate()
			vboxcontainer_name.add_child(new_name)
			new_name.text = name_and_titles[i][0]
			
			var new_title = label_title.duplicate()
			vboxcontainer_title.add_child(new_title)
			new_title.text = name_and_titles[i][1]
		else:
			label_name.text = name_and_titles[i][0]
			label_title.text = name_and_titles[i][1]
	
	# Responsive code to Window Size changes
	get_tree().get_root().size_changed.connect(_on_size_changed)
	call_deferred("_on_size_changed")

func _on_size_changed():
	button_container.position.y = get_viewport().size.y - button_container.size.y - margin_bottom
