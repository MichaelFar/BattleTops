extends BasicUIController


@export var roundsWonNumLabel : RichTextAnimation

@export var topsDefeatedNumLabel : RichTextAnimation

@export var totalMoneyEarnedNumLabel : RichTextAnimation

var roundsWon : int :
	
	set(value):
	
		roundsWon = value
		roundsWonNumLabel.text = str(roundsWon)
		
var topsDefeated : int :
	
	set(value):
	
		topsDefeated = value
		topsDefeatedNumLabel.text = str(topsDefeated)
		
var totalMoneyEarned : int :
	
	set(value):
	
		totalMoneyEarned = value
		totalMoneyEarnedNumLabel.text = str(value)

var playerTop : BattleTop :
	set(value):
		playerTop = value
		

func get_player_top_information(player_top : BattleTop):
	
	topsDefeated = player_top.numTopsDefeated
	totalMoneyEarned = GlobalStats.totalGoldEarned
	roundsWon = GlobalStats.roundNum - 1
