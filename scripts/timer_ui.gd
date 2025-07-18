extends Control

@export var bbcString : String

@export var timerLabel : RicherTextLabel

var timerVal : float :
	
	set(value):
		
		timerVal = value
		
		timerLabel.bbcode = bbcString + str(value)
		
var timerTicking : bool = false

func _physics_process(delta: float) -> void:
	
	if(timerTicking):
		timerVal += delta

func set_hidden(new_value : bool):
	
	visible = !new_value

func start_timer():
	
	timerTicking = true
	print("Started timer")
	visible = true
	
func restart_timer():
	
	timerVal = 0.0
	
func pause_timer():
	
	timerTicking = false
