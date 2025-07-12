extends Node

enum DifficultyLevel {EASY, MEDIUM, HARD, VERYHARD}

enum GameMode {SCREENSAVER, CAREER}

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

var playerStats : Dictionary = {
	stamina : 20.0,
	sturdiness : 40.0,
	spinForce : 100.0
}
