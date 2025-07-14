extends Control

#Very temporary ui stuff

@export var activeArena : ArenaLevelManager

signal said_yes
signal said_no

func _on_button_button_up() -> void: #Yes
	
	said_yes.emit()
	pass # Replace with function body.


func _on_button_2_button_up() -> void: #No
	said_no.emit()
	
	set_hidden(true)

func set_hidden(new_value : bool):
	visible = !new_value
