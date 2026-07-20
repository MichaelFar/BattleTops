extends Upgrade

class_name SpinforceIsCurrentMoneyUpgrade

func triggerEffect():
	ownerTop.maxSpinForce = GlobalStats.goldAmount
