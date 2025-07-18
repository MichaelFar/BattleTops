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

var staminaUpgradeAmount : float
var sturdinessUpgradeAmount : float
var spinForceUpgradeAmount : float

var staminaCost : int = 50:
	
	set(value):
		
		staminaCost = value
		GlobalStats.staminaCost = value
		staminaCostLabel.bbcode = "Cost: " + str(value)
		

var sturdinessCost : int = 50:
	
	set(value):
		
		sturdinessCost = value
		GlobalStats.sturdinessCost = value
		sturdinessCostLabel.bbcode ="Cost: " + str(value)
		

var spinForceCost : int = 50:
	
	set(value):
		
		spinForceCost = value
		GlobalStats.spinForceCost = value
		spinForceCostLabel.bbcode = "Cost: " + str(value)
		

var moneyAmount : int = 0 : 
	
	set(value):
		
		moneyAmount = value
		GlobalStats.goldAmount = value
		moneyAmountValueLabel.bbcode = str(moneyAmount)
		
signal next_round_button_pressed

signal popped_up

func _ready():
	
	update_stats()
	staminaCost = 50
	sturdinessCost = 50
	spinForceCost = 50
	moneyAmount = GlobalStats.goldAmount
	
	staminaUpgradeAmount = GlobalStats.staminaUpgradeAmount
	sturdinessUpgradeAmount = GlobalStats.sturdinessUpgradeAmount
	spinForceUpgradeAmount = GlobalStats.spinForceUpgradeAmount
	
func set_hidden(new_value : bool):
	
	update_stats()
	visible = !new_value
	if(!new_value):
		popped_up.emit()
	

func _on_upgrade_stamina_button_up() -> void:
	
	if(moneyAmount > staminaCost):
		
		moneyAmount -= staminaCost
		staminaCost += staminaCost / 8
		GlobalStats.playerStats["stamina"] += staminaUpgradeAmount
		staminaLabelText = str(GlobalStats.playerStats["stamina"]) 

func _on_upgrade_sturdiness_button_up() -> void:
	
	if(moneyAmount > sturdinessCost):
		
		moneyAmount -= sturdinessCost
		sturdinessCost += sturdinessCost / 8
		GlobalStats.playerStats["sturdiness"] += sturdinessUpgradeAmount
		sturdinessLabelText = str(GlobalStats.playerStats["sturdiness"])
	
	
func _on_upgrade_spin_force_button_up() -> void:
	
	if(moneyAmount > spinForceCost):
		
		moneyAmount -= spinForceCost
		spinForceCost += spinForceCost / 8
		GlobalStats.playerStats["spinForce"] += spinForceUpgradeAmount
		spinForceLabelText = str(GlobalStats.playerStats["spinForce"]) 

func update_stats():
	
	staminaLabelText = str(GlobalStats.playerStats["stamina"]) 
	sturdinessLabelText = str(GlobalStats.playerStats["sturdiness"])
	spinForceLabelText = str(GlobalStats.playerStats["spinForce"]) 
	moneyAmount = GlobalStats.goldAmount
	#staminaCost = GlobalStats.staminaCost
	#sturdinessCost = GlobalStats.sturdinessCost
	#spinForceCost = GlobalStats.spinForceCost


func _on_next_round_button_button_up() -> void:
	
	set_hidden(true)
	next_round_button_pressed.emit()
	
func set_costs_to_default():
	staminaCost = GlobalStats.staminaCost
	sturdinessCost = GlobalStats.sturdinessCost
	spinForceCost = GlobalStats.spinForceCost
