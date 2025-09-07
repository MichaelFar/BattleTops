extends Upgrade

class_name DebugUpgradeThree

func initialize():
	cost = 14.0
	titleString = "Debug Upgrade Sparked"
	descriptionString = "This upgrade prints a statement when the top sparks"
	desiredSignalsList.append(DESIREDTOPSIGNALS.has_sparked)

func triggerEffect():
	
	print("This top has sparked")
