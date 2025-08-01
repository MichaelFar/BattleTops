extends Upgrade

class_name TestOnHitUpgrade

func initialize():
	cost = 100.0
	titleString = "Debug Upgrade"
	descriptionString = "This upgrade prints a statement when the top hits another"
	desiredSignalsList.append(DESIREDTOPSIGNALS.has_hit_top)

func triggerEffect():
	
	print("hit enemy top from upgrade")
	
