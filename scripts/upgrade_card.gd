extends Control

class_name UpgradeCard

@export var upgradeCost : float = 150

@export var costLabel : RicherTextLabel

@export var cardTitle : RicherTextLabel

@export var cardDescription : RicherTextLabel

@export var purchasedPanel : Panel

@export var bbcString : String

@export var upgrade : Upgrade

var formerBBCString : String

var costLabelString : String :
	
	set(value):
		
		costLabelString = value
		if(costLabel != null):
			costLabel.bbcode = "Cost: " + bbcString +str(value)
		
var cardTitleString : String :
	
	set(value):
		
		cardTitleString = value
		if(cardTitle != null):
			cardTitle.bbcode = bbcString + str(value)
		
var cardDescriptionString : String :
	
	set(value):
		
		cardDescriptionString = value
		if(cardTitle != null):
			cardDescription.bbcode = bbcString + str(value)

signal purchased_upgrade(upgradeCost, upgrade)

func _ready():
	
	new_upgrade()
	
	formerBBCString = bbcString
	#upgrade.triggerSignal = 
	
func purchase_upgrade():
	
	if(upgrade != null):
		
		upgrade = upgrade.get_script().new()
		upgrade.has_been_purchased.connect(set_card_to_purchased)
		purchased_upgrade.emit(upgradeCost, upgrade)
		
	upgrade = null
	
func shuffle_upgrades():
	
	var rand_obj := RandomNumberGenerator.new()
	
	var upgradeListWithRemoval := GlobalStats.availableUpgradeArray
	
	print("Size of upgrade list is " + str(upgradeListWithRemoval))
	
	var rand_index := rand_obj.randi_range(0, upgradeListWithRemoval.size() - 1)
	
	if(upgradeListWithRemoval.size() > 0):
		var upgrade_object = GlobalStats.upgradeClassDict[upgradeListWithRemoval[rand_index]].new()
		
		upgrade = upgrade_object
		
		upgradeCost = upgrade.cost
	
		populate_text_from_upgrade()
	else:
		set_card_to_purchased()
	#
	#upgradeParent.call_deferred("add_child", upgrade_card_object)
	#
	##upgradeListWithRemoval.pop_at(rand_index)

func populate_text_from_upgrade():
	
	costLabelString = str(upgradeCost)
	#costLabelString = upgrade.costLabelString
	cardTitleString = upgrade.titleString
	cardDescriptionString = upgrade.descriptionString
	
func set_card_to_purchased():
	
	bbcString = ""
	purchasedPanel.show()
	
func new_upgrade():
	
	bbcString = formerBBCString
	
	purchasedPanel.hide()
	
	shuffle_upgrades()
