extends Upgrade

class_name StaminaGainFromHitUpgrade

@export var staminaMult : float = 1.5

func triggerEffect():
	
	ownerTop.staminaGainMult = staminaMult
