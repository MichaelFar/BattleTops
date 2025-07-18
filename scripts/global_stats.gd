extends Node

class_name Global

enum DifficultyLevel {EASY, MEDIUM, HARD, VERYHARD}

enum GameMode {SCREENSAVER, CAREER}

enum GameStage {SCREENSAVER, CHOOSINGTOP, UPGRADESCREEN, MAINROUND}

enum GameDifficulty {EARLY, MID, LATE}

var defaultGoldAmount := 200

var currentGameStage : GameStage = GameStage.SCREENSAVER

var currentGameMode : GameMode = GameMode.SCREENSAVER :
	
	set(value):
		
		currentGameMode = value
		
	get():
		
		return currentGameMode

var currentDifficulty : DifficultyLevel = DifficultyLevel.EASY

var stamina : float = 20

var maxStamina : float = 40

var sturdiness : float = 40

var maxSturdiness : float = 80

var spinForce : float = 100

var maxSpinForce : float = 150

var infiniteStaminaMode : bool = false

var goldAmount : int = 200

var staminaCost : int = 50

var sturdinessCost : int = 50

var spinForceCost : int = 50

var staminaUpgradeAmount : float = 15
var sturdinessUpgradeAmount : float = 20
var spinForceUpgradeAmount : float = 25


var numEnemyTops := 1

var roundNum : int = 0

var playerStats : Dictionary = {
	"stamina" : 20.0,
	"sturdiness" : 40.0,
	"spinForce" : 100.0
}

var opponentTopRangeDict : Dictionary = { #Increases when round num increases
	"stamina" : Vector2(1,1),
	"sturdiness" : Vector2(1,1),
	"spinForce" : Vector2(1,1)
}

func set_player_stats(new_stamina : float, new_sturdiness : float, new_spin_force : float):
	
	playerStats["stamina"] = new_stamina
	playerStats["sturdiness"] = new_sturdiness
	playerStats["spinForce"] = new_spin_force

func update_enemy_tops_and_advance_difficulty():
	
	roundNum += 1
	
	match roundNum:
		
		1:
			opponentTopRangeDict["stamina"] = Vector2(1, 20)
			opponentTopRangeDict["sturdiness"] = Vector2(20, 50)
			opponentTopRangeDict["spinForce"] = Vector2(30, 60)
		3:
			opponentTopRangeDict["stamina"] = Vector2(10, 40)
			opponentTopRangeDict["sturdiness"] = Vector2(50, 90)
			opponentTopRangeDict["spinForce"] = Vector2(70, 110)
		5:
			opponentTopRangeDict["stamina"] = Vector2(30, 60)
			opponentTopRangeDict["sturdiness"] = Vector2(70, 130)
			opponentTopRangeDict["spinForce"] = Vector2(100, 150)
		7:
			opponentTopRangeDict["stamina"] = Vector2(60, 90)
			opponentTopRangeDict["sturdiness"] = Vector2(100, 150)
			opponentTopRangeDict["spinForce"] = Vector2(130, 180)
