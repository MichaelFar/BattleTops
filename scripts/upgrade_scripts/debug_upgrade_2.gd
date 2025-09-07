extends Upgrade

class_name DebugUpgradeTwo

func initialize():
	cost = 10.0
	titleString = "Debug Upgrade Stamina"
	descriptionString = "This upgrade prints a statement when the top has low stamina"
	desiredSignalsList.append(DESIREDTOPSIGNALS.has_low_stamina)

func triggerEffect():
	
	print("top has low stamina")
