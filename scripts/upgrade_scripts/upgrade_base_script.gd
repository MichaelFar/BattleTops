extends Resource

#Please note that any and all references to a Resource object must be deleted,
#Unlike ordinary node objects they do not free themselves upon removal from the tree as they are not a node
#Manual freeing is forbidden, must free by removing all references to the object, we free this memory in BattleTop.kill_top()

class_name Upgrade

var triggerSignals : Array[Signal]

@export var desiredSignalsList : Array[DESIREDTOPSIGNALS]

@export var cost := 11.0

var costLabelString : String

var ownerTop : BattleTop

@export var titleString : String

@export var descriptionString : String

enum DESIREDTOPSIGNALS {has_hit_top, hit_begun, hit_end, first_hit_occured, has_sparked, has_low_stamina, new_round_has_begun}

signal has_been_purchased

signal end_of_initialization

func _init() -> void:
	
	initialize()
	costLabelString = str(cost)
	print ("Upgrade initialized")

func initialize_signals():
	
	connect_upgrade_signals()

	for i in triggerSignals:
		
		if(!i.is_connected(triggerEffect)):
			i.connect(triggerEffect)
	
	end_of_initialization.emit()


func triggerEffect():
	print("triggered effect")

func addSignalToList(new_signal : Signal):
	
	triggerSignals.append(new_signal)

func initialize():
	titleString = "Debug Upgrade"
	descriptionString = "This upgrade is the base class for upgrades, nothing will trigger it"

func connect_upgrade_signals():
	
	print("Connecting upgrade signals")
	
	for i in desiredSignalsList:
		
		if (i == DESIREDTOPSIGNALS.has_hit_top):
			
			addSignalToList(ownerTop.has_hit_top)
			#upgrade.connect_signals()
		if (i == DESIREDTOPSIGNALS.first_hit_occured):
			
			addSignalToList(ownerTop.first_hit_occured)
			
		if (i == DESIREDTOPSIGNALS.has_sparked):
			
			addSignalToList(ownerTop.has_sparked)
			
		if (i == DESIREDTOPSIGNALS.has_low_stamina):
			
			addSignalToList(ownerTop.has_low_stamina)

		if (i == DESIREDTOPSIGNALS.hit_begun):
			
			addSignalToList(ownerTop.hit_begun)

		if (i == DESIREDTOPSIGNALS.hit_end):
			
			addSignalToList(ownerTop.hit_end)
		
		if(i == DESIREDTOPSIGNALS.new_round_has_begun):
			
			addSignalToList(ownerTop.new_round_has_begun)
