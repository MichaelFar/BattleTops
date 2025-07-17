extends BasicUIController

@export var timeBonusLabel : RicherTextLabel
@export var opDifBonusLabel : RicherTextLabel
@export var totalScoreLabel : RicherTextLabel

@export var bbcodeString : String

var timeBonus : int :
	set(value):
		timeBonus = value
		timeBonusLabel.bbcode = bbcodeString + str(value)

var opDifBonus : int :
	set(value):
		opDifBonus = value
		opDifBonusLabel.bbcode = bbcodeString + str(value)

var totalScore : int :
	set(value):
		timeBonus = value
		timeBonusLabel.bbcode = bbcodeString + str(value)

func animate_score():
	
	var timer_delta : float = 0.1
	
	var timeBonusTimer = get_tree().create_timer(timer_delta)
	
	await timeBonusTimer.timeout
	
	var opDifBonusTimer = get_tree().create_timer(timer_delta)
	
	await opDifBonusTimer.timeout
	
	var totalScoreTimer = get_tree().create_timer(timer_delta)
	
	await totalScoreTimer.timeout

func calculate_score():
	pass
