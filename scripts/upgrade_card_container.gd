extends HBoxContainer

var upgradeCardChildren := []

var upgradeCardChosenArray : Array[bool] = [false, false, false]

var upgradeChosenIndex := 0

func _ready():
	
	upgradeCardChildren = get_children()
	#GlobalStats.populate_post_purchase_array()
	
func receive_chosen_signal():
	
	upgradeCardChosenArray[upgradeChosenIndex] = true
	
	upgradeChosenIndex = clamp(upgradeChosenIndex + 1, 0, upgradeCardChosenArray.size() - 1)
	
	if(upgradeCardChosenArray.size() - 1 == upgradeChosenIndex):
		
		print("All cards have chosen an upgrade")
		upgradeChosenIndex = 0
		upgradeCardChosenArray = [false, false, false]
		
		
		
		
	
