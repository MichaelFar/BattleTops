extends Node3D

@export var playerTopScene : PackedScene

@export var spawnMarker : Marker3D

@export var orientPoint : Marker3D

func _ready():
	
	GlobalStats.infiniteStaminaMode = true
	spawn_player_top()
	
func spawn_player_top():
	
	var player_top_object : BattleTop = playerTopScene.instantiate()
	
	add_child(player_top_object)
	
	player_top_object.global_position = spawnMarker.global_position
	player_top_object.orientPoint = orientPoint
	
