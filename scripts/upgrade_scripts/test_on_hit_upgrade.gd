extends Upgrade

class_name TestOnHitUpgrade

func initialize():
	
	desiredSignalsList.append(DESIREDTOPSIGNALS.has_hit_top)

func triggerEffect():
	
	print("hit enemy top from upgrade")
