extends Upgrade
#maybe add a particle effect here?
class_name GainMoneyUpgrade
@export var moneyToGain : int = 5

func triggerEffect():
	GlobalStats.goldAmount += moneyToGain
