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

@export var staminaCostLabel : RicherTextLabel
@export var sturdinessCostLabel : RicherTextLabel
@export var spinForceCostLabel : RicherTextLabel

@export var moneyAmountValueLabel : RicherTextLabel

@export var staminaUpgradeAmount : float
@export var sturdinessUpgradeAmount : float
@export var spinForceUpgradeAmount : float

var staminaCost : int :
	
	set(value):
		
		staminaCost = value
		staminaCostLabel.bbcode = "Cost: " +str(staminaCost)
		GlobalStats.staminaCost = value

var sturdinessCost : int:
	
	set(value):
		
		sturdinessCost = value
		sturdinessCostLabel.bbcode ="Cost: " + str(sturdinessCost)
		GlobalStats.sturdinessCost = value

var spinForceCost : int:
	
	set(value):
		
		spinForceCost = value
		spinForceCostLabel.bbcode = "Cost: " +str(spinForceCost)
		GlobalStats.spinForceCost = value

var moneyAmount : int = 0 : 
	
	set(value):
		
		moneyAmount = value
		moneyAmountValueLabel.bbcode = str(moneyAmount)
		GlobalStats.goldAmount = value		
		
		

signal next_round_button_pressed

func _ready():
	
	update_stats()
	
	moneyAmount = GlobalStats.goldAmount
	
func set_hidden(new_value : bool):
	update_stats()
	visible = !new_value

func _on_upgrade_stamina_button_up() -> void:
	pass # Replace with function body.


func _on_upgrade_sturdiness_button_up() -> void:
	pass # Replace with function body.


func _on_upgrade_spin_force_button_up() -> void:
	pass # Replace with function body.

func update_stats():
	staminaLabelText = str(GlobalStats.playerStats["stamina"]) 
	sturdinessLabelText = str(GlobalStats.playerStats["sturdiness"])
	spinForceLabelText = str(GlobalStats.playerStats["spinForce"]) 
	
	staminaCost = GlobalStats.staminaCost
	sturdinessCost = GlobalStats.sturdinessCost
	spinForceCost = GlobalStats.spinForceCost


func _on_next_round_button_button_up() -> void:
	set_hidden(true)
	next_round_button_pressed.emit()
	
