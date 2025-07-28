extends Resource

class_name Upgrade

var triggerSignals : Array[Signal]

var desiredSignalsList : Array[DESIREDTOPSIGNALS]

enum DESIREDTOPSIGNALS {has_hit_top, first_hit_occured, has_sparked, has_low_stamina}

func _init() -> void:
	
	initialize()
	print ("Upgrade initialized")

func connect_signals():
	
	for i in triggerSignals:
		
		if(!i.is_connected(triggerEffect)):
			i.connect(triggerEffect)

func triggerEffect():
	print("triggered effect")

func addSignalToList(new_signal : Signal):
	
	triggerSignals.append(new_signal)

func initialize():
	pass
