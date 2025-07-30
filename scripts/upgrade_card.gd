extends Control

class_name UpgradeCard

@export var upgradeCost : float = 150

@export var costLabel : RicherTextLabel

@export var bbcString : String

@export var upgrade : Upgrade

var costLabelString : String :
	
	set(value):
		
		costLabelString = value
		if(costLabel != null):
			costLabel.bbcode = "Cost: " + bbcString +str(value)
		

signal purchased_upgrade(upgradeCost, upgrade)

func _ready():
	
	costLabelString = str(upgradeCost)
	#upgrade.triggerSignal = 
	
func purchase_upgrade():
	
	upgrade = upgrade.get_script().new()
	
	purchased_upgrade.emit(upgradeCost, upgrade)
	
	upgrade = null
	
