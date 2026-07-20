extends Upgrade

class_name SpinforceIsCurrentMoneyUpgrade

func triggerEffect():
	ownerTop.maxSpinforce = GlobalStats.goldAmount
