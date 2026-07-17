extends Upgrade

class_name OnHitUpgrade

func initialize():
	cost = 10.0
	titleString = "Debug Upgrade"
	descriptionString = "This upgrade prints a statement when the top hits another"
	desiredSignalsList.append(DESIREDTOPSIGNALS.has_hit_top)

func triggerEffect():
	
	print("hit enemy top from upgrade")
		
