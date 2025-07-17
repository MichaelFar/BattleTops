extends Control

class_name BasicUIController
#Very temporary ui stuff

@export var activeArena : ArenaLevelManager

signal said_yes
signal said_no

signal popped_up

func _on_button_button_up() -> void: #Yes
	
	said_yes.emit()
	pass # Replace with function body.

func set_hidden(new_value : bool):
	visible = !new_value
	
	if(!new_value):
		popped_up.emit()
