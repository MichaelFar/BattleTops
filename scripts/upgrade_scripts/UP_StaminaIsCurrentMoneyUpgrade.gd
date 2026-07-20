extends Upgrade

class_name StaminaIsCurrentMoneyUpgrade

func triggerEffect():
	ownerTop.maxStamina = GlobalStats.goldAmount
