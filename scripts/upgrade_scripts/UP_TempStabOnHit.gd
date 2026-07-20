extends Upgrade

class_name TempStabilityIncreaseUpgrade

@export var sturdinessMult : float = 1.5

func initialize():
	end_of_initialization.connect(connectHitEnd)

func triggerEffect():
	print("Increasing top sturdiness at low stamina")
	ownerTop.sturdinessMult = sturdinessMult

func connectHitEnd():
	ownerTop.hit_end.connect(resetStability)

func resetStability():
	print("Resetting stability")
	ownerTop.sturdinessMult = 1.0
