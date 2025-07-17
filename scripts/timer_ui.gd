extends Control

@export var gameTimer : Timer

@export var bbcString : String

@export var timerLabel : RicherTextLabel

var timerVal : int :
	
	set(value):
		
		timerVal = value
		
		timerLabel.bbcode = bbcString + str(value)
		

func start_timer():
	
	gameTimer.start()
	
	visible = true
	
func _physics_process(delta: float) -> void:
	
	timerVal =   clampf(gameTimer.time_left, 0.0, gameTimer.wait_time)

func restart_timer():
	
	gameTimer.stop()
	gameTimer.start()
	
func pause_timer():
	
	gameTimer.stop()
