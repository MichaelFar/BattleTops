@tool
extends Control

class_name StatLabelController

@export var staminaLabel : RicherTextLabel
@export var sturdinessLabel : RicherTextLabel
@export var spinForceLabel : RicherTextLabel

@export var staminaLabelText : String :
	set(value):
		
		staminaLabelText = value
		staminaLabel.bbcode = staminaLabelText
		
	get():
		return staminaLabelText
		
@export var sturdinessLabelText : String :
	
	set(value):
		
		sturdinessLabelText = value
		sturdinessLabel.bbcode = sturdinessLabelText
		
	get():
		return sturdinessLabelText
		
@export var spinForceLabelText : String :
	
	set(value):
		
		spinForceLabelText = value
		spinForceLabel.bbcode = spinForceLabelText
		
	get():
		return spinForceLabelText

var staminaCost : float

var sturdinessCost : float

var spinForceCost : float
func _ready():
	
	staminaLabelText = str(GlobalStats.playerStats["stamina"])
	sturdinessLabelText = str(GlobalStats.playerStats["sturdiness"])
	spinForceLabelText = str(GlobalStats.playerStats["spinForce"])
	
func set_hidden(new_value : bool):
	
	visible = !new_value

func _on_upgrade_stamina_button_up() -> void:
	pass # Replace with function body.


func _on_upgrade_sturdiness_button_up() -> void:
	pass # Replace with function body.


func _on_upgrade_spin_force_button_up() -> void:
	pass # Replace with function body.
