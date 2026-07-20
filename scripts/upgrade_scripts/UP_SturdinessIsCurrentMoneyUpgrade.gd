extends Upgrade

class_name SturdinessIsCurrentMoneyUpgrade

func triggerEffect():
	ownerTop.maxSturdiness = GlobalStats.goldAmount
