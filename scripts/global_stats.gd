extends Node

class_name Global

enum DifficultyLevel {EASY, MEDIUM, HARD, VERYHARD}

enum GameMode {SCREENSAVER, CAREER}

enum GameStage {SCREENSAVER, CHOOSINGTOP, UPGRADESCREEN, MAINROUND}

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

var playerStats : Dictionary = {
	"stamina" : 20.0,
	"sturdiness" : 40.0,
	"spinForce" : 100.0
}

func set_player_stats(new_stamina : float, new_sturdiness : float, new_spin_force : float):
	
	playerStats["stamina"] = new_stamina
	playerStats["sturdiness"] = new_sturdiness
	playerStats["spinForce"] = new_spin_force
