extends Control

class_name UpgradeCard

@export var upgradeCost : float = 150

@export var costLabel : RicherTextLabel

@export var bbcString : String

var costLabelString : String :
	
	set(value):
		
		costLabelString = value
		costLabel.bbcode = "Cost: " + bbcString +str(value)
		

signal purchased_upgrade(upgradeCost)

func _ready():
	
	costLabelString = str(upgradeCost)
	
func purchase_upgrade():
	
	purchased_upgrade.emit(upgradeCost)
