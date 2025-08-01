extends Control

class_name UpgradeCard

@export var upgradeCost : float = 150

@export var costLabel : RicherTextLabel

@export var cardTitle : RicherTextLabel

@export var cardDescription : RicherTextLabel

@export var bbcString : String

@export var upgrade : Upgrade

var upgradeClassDict : Dictionary = {
	
	"debugHitUpgrade" : TestOnHitUpgrade,
	"baseUpgrade" : Upgrade
	
}

var costLabelString : String :
	
	set(value):
		
		costLabelString = value
		if(costLabel != null):
			costLabel.bbcode = "Cost: " + bbcString +str(value)
		
var cardTitleString : String :
	
	set(value):
		
		cardTitleString = value
		if(cardTitle != null):
			cardTitle.bbcode = bbcString +str(value)
		

var cardDescriptionString : String :
	
	set(value):
		
		cardDescriptionString = value
		if(cardTitle != null):
			cardDescription.bbcode = bbcString +str(value)
		


signal purchased_upgrade(upgradeCost, upgrade)

func _ready():
	
	shuffle_upgrades()
	costLabelString = str(upgradeCost)
	#upgrade.triggerSignal = 
	
func purchase_upgrade():
	
	upgrade = upgrade.get_script().new()
	
	purchased_upgrade.emit(upgradeCost, upgrade)
	
	upgrade = null
	
func shuffle_upgrades():
	var rand_obj := RandomNumberGenerator.new()
	
	var upgradeListWithRemoval := upgradeClassDict.keys()
	
	print("Size of upgrade list is " + str(upgradeListWithRemoval))
	
	var rand_index := rand_obj.randi_range(0, upgradeListWithRemoval.size() - 1)
	
	var upgrade_object = upgradeClassDict[upgradeListWithRemoval[rand_index]].new()
	
	upgrade = upgrade_object
	populate_text_from_upgrade()
	#
	#upgradeParent.call_deferred("add_child", upgrade_card_object)
	#
	##upgradeListWithRemoval.pop_at(rand_index)

func populate_text_from_upgrade():
	
	costLabelString = upgrade.costLabelString
	cardTitleString = upgrade.titleString
	cardDescriptionString = upgrade.descriptionString
	upgradeCost = upgrade.cost
	
