extends BasicUIController

@export var timeBonusLabel : RicherTextLabel
@export var opDifBonusLabel : RicherTextLabel
@export var totalScoreLabel : RicherTextLabel

@export var roundHeaderLabel : RicherTextLabel



@export var bbcodeString : String

var roundHeaderString : String :
	set(value):
		roundHeaderString = value
		roundHeaderLabel.bbcode = "\n" + bbcodeString + value

var timeBonus : float :
	set(value):
		timeBonus = value
		timeBonusLabel.bbcode = "\n" + bbcodeString + str(value)

var opDifBonus : float :
	set(value):
		opDifBonus = value
		opDifBonusLabel.bbcode = "\n" + bbcodeString + str(value)

var totalScore : float :
	set(value):
		totalScore = value
		totalScoreLabel.bbcode = bbcodeString + str(value)

var receivedTime : float

var receivedStatDictionaryArray : Array[Dictionary] :
	set(value):
		receivedStatDictionaryArray = value
		print("Dictionary array set to " + str(value))

signal calculated_score

func _ready():
	
	popped_up.connect(calculate_score)

func animate_score(finalTimeBonus : float, finalOpDifBonus : float, finalTotalScore : float):
	
	var timer_delta : float = 0.4
	
	var timeBonusTimer = get_tree().create_timer(timer_delta)
	
	await timeBonusTimer.timeout
	
	timeBonus = finalTimeBonus
	
	var opDifBonusTimer = get_tree().create_timer(timer_delta)
	
	await opDifBonusTimer.timeout
	
	opDifBonus = finalOpDifBonus
	
	var totalScoreTimer = get_tree().create_timer(timer_delta)
	
	await totalScoreTimer.timeout
	
	totalScore = finalTotalScore
	
func calculate_score():
	
	var time_bonus : float = 0.0
	
	if(receivedTime < 5.0):
		time_bonus += 70.0
	elif(receivedTime < 15.0):
		time_bonus += 40
	elif(receivedTime < 25.0):
		time_bonus += 20
	
	var op_dif_bonus : float = 0.0
	
	print("Received dictionary array is " + str(receivedStatDictionaryArray))
	
	for i in receivedStatDictionaryArray:
		print(i)
		op_dif_bonus += i["stamina"] + i["sturdiness"] + i["spinForce"]
	
	op_dif_bonus = op_dif_bonus / 3.0
	
	GlobalStats.goldAmount += (time_bonus + op_dif_bonus)
	
	animate_score(time_bonus, op_dif_bonus, time_bonus + op_dif_bonus)

func update_header_text():
	
	roundHeaderString = str("Round " + str(GlobalStats.roundNum) + " Won!")
