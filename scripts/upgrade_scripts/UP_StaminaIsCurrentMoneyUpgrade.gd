extends Upgrade

class_name StaminaIsCurrentMoneyUpgrade

func triggerEffect():
	ownerTop.maxStamina = GlobalStats.goldAmount
	ownerTop.set_stamina_to_max()
