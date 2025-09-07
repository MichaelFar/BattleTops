extends Resource

#Please note that any and all references to a Resource object must be deleted,
#Unlike ordinary node objects they do not free themselves upon removal from the tree as they are not a node
#Manual freeing is forbidden, must free by removing all references to the object, we free this memory in BattleTop.kill_top()

class_name Upgrade

var triggerSignals : Array[Signal]

var desiredSignalsList : Array[DESIREDTOPSIGNALS]

@export var cost := 11.0

var costLabelString : String

@export var titleString : String

@export var descriptionString : String

enum DESIREDTOPSIGNALS {has_hit_top, first_hit_occured, has_sparked, has_low_stamina}

signal has_been_purchased

func _init() -> void:
	
	initialize()
	costLabelString = str(cost)
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
	titleString = "Debug Upgrade"
	descriptionString = "This upgrade is the base class for upgrades, nothing will trigger it"
