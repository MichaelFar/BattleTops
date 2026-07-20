extends Upgrade

class_name GainStaminaUpgrade

@export var gainCoefficient : float = 0.1

func triggerEffect():
	
	ownerTop.stamina += ownerTop.maxStamina * gainCoefficient
