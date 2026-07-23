extends Upgrade

class_name TempSturdinessFlatGainUpgrade

@export var amountToIncrement : float = 10

var amountIncremented : float = 0.0

func initialize():
	GlobalStats.next_round_started.connect(resetTotalAmountIncremented)

func triggerEffect():
	amountIncremented += amountToIncrement
	ownerTop.flatSturdinessBonus += amountIncremented

func resetTotalAmountIncremented():
	if(ownerTop != null):
		ownerTop.flatSturdinessBonus -= amountIncremented
		amountIncremented = 0.0
