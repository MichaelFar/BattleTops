extends Node3D

class_name ArenaLevelManager

@export var orientPoint : Marker3D

@export var spawnMarkerArray : Array[Marker3D]

@export var spawnTimer : Timer

@export var battleTopScene : PackedScene

@export var numRounds : int = -1

@export var popupUI : Control

@export var upgradeUI : Control

@export var restartUI : Control

@export var nextRoundUI : Control

var topChildren : Array[BattleTop]

var hasChosenTop : bool = false

var playerTop : BattleTop

func _ready() -> void:
	
	GlobalStats.currentGameStage = GlobalStats.GameStage.CHOOSINGTOP
	
	GlobalStats.currentGameMode = GlobalStats.GameMode.CAREER
	
	popupUI.set_hidden(true)
	
	spawnTimer.timeout.connect(spawn_battle_top)
	
	

func next_round():
	
	spawn_battle_top()
	playerTop.stamina = playerTop.maxStamina
	playerTop.create_stamina_tween()

func spawn_battle_top():
	
	print("spawning battle top")
	
	if(playerTop == null):
		for i in spawnMarkerArray.size():
			
			var top_object : BattleTop = battleTopScene.instantiate()
			var rand_obj := RandomNumberGenerator.new()
			
			add_child(top_object)
			top_object.global_position = spawnMarkerArray[i].global_position
			top_object.orientPoint = orientPoint
			topChildren.append(top_object)
			print("spawned top")
			
			if(i == 0 
			&& GlobalStats.currentGameMode == GlobalStats.GameMode.CAREER
			&& playerTop == null):
				
				top_object.isPlayer = true
				
			top_object.shouldBeRandom = !top_object.isPlayer
			#top_object.global_position = spawnMarkerArray[rand_obj.randi_range(0, spawnMarkerArray.size() - 1)].global_position
	else:
		
		for i in GlobalStats.numEnemyTops:
			
			var top_object : BattleTop = battleTopScene.instantiate()
			var rand_obj := RandomNumberGenerator.new()
			
			add_child(top_object)
			top_object.global_position = spawnMarkerArray[i].global_position
			top_object.orientPoint = orientPoint
			topChildren.append(top_object)
			print("spawned top")
		
				
			top_object.shouldBeRandom = !top_object.isPlayer
	numRounds -= 1
	
	if(numRounds != 0 && spawnTimer.is_stopped() && GlobalStats.currentGameMode == GlobalStats.GameMode.SCREENSAVER):
		
		spawnTimer.start()

func _physics_process(delta: float) -> void:
	
	if(Input.is_action_just_released("ui_accept")):
		
		numRounds  = -1
		
		spawn_battle_top()
		
	if(Input.is_action_just_released("debug_restart")):
		
		restart_round_with_random()
		
func restart_round_with_random():
	
	for i in topChildren:
		
		if(i != null):
			
			i.queue_free()
	
	topChildren = []
	
	spawnTimer.stop()
	
	spawn_battle_top()

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if(body is BattleTop):
		
		var battle_top : BattleTop = body
		
		battle_top.insideArena = true
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	
	if(body is BattleTop):
		
		var battle_top : BattleTop = body
		
		battle_top.insideArena = false

func _on_kill_plane_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	
	if(body is BattleTop):
		print("Top hit death plane")
		topChildren.pop_at(topChildren.find(body))
		
		if(GlobalStats.currentGameStage == GlobalStats.GameStage.CHOOSINGTOP):
			
			if(topChildren.size() == 1 && !hasChosenTop):
				
				popupUI.set_hidden(false)
			
			if(topChildren.size() == 0):
				
				popupUI.set_hidden(true)
				
				restart_round_with_random()
			
			if(body == playerTop):
				
				print("Player has died")
				
				restartUI.set_hidden(false)
				
				playerTop = null
		
			if(topChildren[0] == playerTop && topChildren.size() == 1):
				
				nextRoundUI.set_hidden(false)
				
		body.kill_top()
		
func _on_prompt_ui_said_yes() -> void:
	
	popupUI.set_hidden(true)
	
	hasChosenTop = true
	
	var timer = get_tree().create_timer(1.0)
	
	var chosenTop : BattleTop = topChildren[0]
	
	playerTop = chosenTop
	
	GlobalStats.playerStats["stamina"] = chosenTop.maxStamina
	GlobalStats.playerStats["sturdiness"] = chosenTop.maxSturdiness
	GlobalStats.playerStats["spinForce"] = chosenTop.maxSpinForce
	
	timer.timeout.connect(upgradeUI.set_hidden.bind(false))
	
func _on_prompt_ui_restart_round_said_yes() -> void:
	
	hasChosenTop = false
	restartUI.set_hidden(true)
	GlobalStats.goldAmount = GlobalStats.defaultGoldAmount
	restart_round_with_random()

func update_player_top_stats():
	
	playerTop.update_stats()

func _on_round_end_ui_said_yes() -> void:
	
	upgradeUI.set_hidden(false)
	nextRoundUI.set_hidden(true)
