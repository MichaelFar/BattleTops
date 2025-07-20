extends Node3D

class_name ArenaLevelManager

@export var orientPoint : Marker3D

@export var spawnMarkerArray : Array[Marker3D]

@export var spawnTimer : Timer

@export var battleTopScene : PackedScene

@export var numRounds : int = -1

@export var popupUI : BasicUIController

@export var upgradeUI : Control

@export var restartUI : BasicUIController

@export var nextRoundUI : BasicUIController

@export var oopsUI : Control

@export var camera : Camera3D

@export var gameTimerUI : Control

@export var popUpUIArray : Array[Control]

@export var rampColliderArray : Array[CollisionShape3D]

@export var safetyBarrierCollider : CollisionShape3D

@export var playerSafetyBarrier : PlayerSafetyBarrier

var topChildren : Array[BattleTop]

var hasChosenTop : bool = false

var playerTop : BattleTop :
	
	set(value):
		
		playerTop = value
		
		print("Set player top to " + str(value))
		
		restartUI.playerTop = playerTop
		
		if(playerTop != null):
			playerTop.collision_mask = playerSafetyBarrier.player_collision_mask
			playerTop.first_hit_occured.connect(gameTimerUI.start_timer)
			playerTop.first_hit_occured.connect(gameTimerUI.restart_timer)
			playerTop.first_hit_occured.connect(playerSafetyBarrier.set_disabled_collision.bind(true))
			

var timeSinceLastHit : float = 0.0

var shouldBeCounting : bool = true :
	
	set(value):
		
		shouldBeCounting = value
		
var originalTimeScale : float

var opponentStatDictionaryArray : Array[Dictionary]

func _ready() -> void:
	
	GlobalStats.currentGameStage = GlobalStats.GameStage.CHOOSINGTOP
	
	GlobalStats.currentGameMode = GlobalStats.GameMode.CAREER
	
	popupUI.set_hidden(true)
	
	connect_ui_hidden_signals()
	
	spawnTimer.timeout.connect(spawn_battle_top)
	
	originalTimeScale = Engine.time_scale
	#camera.set_is_shaking(1.0)

func _physics_process(delta: float) -> void:
	
	timeSinceLastHit += delta
	
	if(timeSinceLastHit > 20.0 && shouldBeCounting):
		
		shouldBeCounting = false
		
		for i in topChildren:
			
			print("Applying impulse")
			i.apply_central_impulse(-topChildren[0].global_position.direction_to(i.global_position) * 10)
	
	#if(timeSinceLastHit > 20.0):
		#safetyBarrierCollider.disabled = false
	#else:
		#safetyBarrierCollider.disabled = true
	
	#if((int(timeSinceLastHit) % int(20.0)) == 0 && shouldBeCounting):
		#for i in topChildren:
			#i.apply_central_impulse(-i.global_position.direction_to(i.linear_velocity) * 10)
	
	if(Input.is_action_just_released("ui_accept")):
		
		numRounds  = -1
		
		spawn_battle_top()
		
	if(Input.is_action_just_released("debug_restart")):
		
		restart_round_with_random()
		

func next_round():
	
	GlobalStats.update_enemy_tops_and_advance_difficulty()
	playerSafetyBarrier.set_disabled_collision(false)
	set_spawn_ramp_collision_disabled(false)
	spawn_battle_top()
	update_player_top_stats()
	playerTop.set_stamina_is_going_down(true)
	
	print("Player Stamina after next round is " + str(playerTop.stamina))
	

func spawn_battle_top():
	
	print("spawning battle top")
	
	restart_idle_timer()
	
	if(playerTop == null):
		
		for i in spawnMarkerArray.size():
			
			var top_object : BattleTop = battleTopScene.instantiate()
			var rand_obj := RandomNumberGenerator.new()
			
			add_child(top_object)
			top_object.global_position = spawnMarkerArray[i].global_position
			top_object.orientPoint = orientPoint
			topChildren.append(top_object)
			print("spawned top")
			
			top_object.has_hit_top.connect(camera.set_is_shaking.bind(0.02))
			#top_object.first_hit_occured.connect(gameTimerUI.start_timer)
			top_object.has_hit_top.connect(restart_idle_timer)
			top_object.first_hit_occured.connect(set_spawn_ramp_collision_disabled.bind(true))
			
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
			top_object.first_hit_occured.connect(set_spawn_ramp_collision_disabled.bind(true))
			print("spawned top")
			top_object.has_hit_top.connect(restart_idle_timer)
			
			top_object.shouldBeRandom = !top_object.isPlayer
	numRounds -= 1
	
	if(numRounds != 0 && spawnTimer.is_stopped() && GlobalStats.currentGameMode == GlobalStats.GameMode.SCREENSAVER):
		
		spawnTimer.start()


func restart_round_with_random():
	
	set_spawn_ramp_collision_disabled(false)
	
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
				
				if(playerTop == null):
			
					oopsUI.set_hidden(false)
			
			if(body != playerTop && playerTop != null):
				
				print("Defeated top stats are " + str(body.topStats))
				
				opponentStatDictionaryArray.append(body.topStats)
				nextRoundUI.receivedStatDictionaryArray = opponentStatDictionaryArray
				
			if(topChildren.size() == 1):
				
				if(topChildren[0] == playerTop ):
				
					nextRoundUI.receivedTime = gameTimerUI.timerVal
					#print("Sent dictionary is " + str(opponentStatDictionaryArray))
					playerSafetyBarrier.set_disabled_collision(false)
					#safetyBarrierCollider.disabled = false
					nextRoundUI.set_hidden(false)
					playerTop.set_stamina_is_going_down(false)
					opponentStatDictionaryArray = []
				else:
					print("Defeated player stats: " + str(GlobalStats.playerStats))
					print("Top stats that defeated the player: " + str(topChildren[0].topStats))
			if(body == playerTop):
				
				print("Player has died")
				
				restartUI.set_hidden(false)
				restartUI.get_player_top_information(playerTop)
				playerTop = null
			
		body.kill_top()
		
func _on_prompt_ui_said_yes() -> void:
	
	popupUI.set_hidden(true)
	
	playerSafetyBarrier.set_disabled_collision(true)
	
	hasChosenTop = true
	
	var timer = get_tree().create_timer(1.0)
	
	var chosenTop : BattleTop = topChildren[0]
	
	playerTop = chosenTop
	
	GlobalStats.playerStats["stamina"] = chosenTop.maxStamina
	GlobalStats.playerStats["sturdiness"] = chosenTop.maxSturdiness
	GlobalStats.playerStats["spinForce"] = chosenTop.maxSpinForce
	
	shouldBeCounting = false
	
	timer.timeout.connect(upgradeUI.set_hidden.bind(false))
	
func _on_prompt_ui_restart_round_said_yes() -> void:
	
	safetyBarrierCollider.disabled = true
	
	playerSafetyBarrier.set_disabled_collision(true)
	
	set_spawn_ramp_collision_disabled(false)
	
	hasChosenTop = false
	restartUI.set_hidden(true)
	oopsUI.set_hidden(true)
	nextRoundUI.set_hidden(true)
	upgradeUI.set_hidden(true)
	gameTimerUI.set_hidden(true)
	
	GlobalStats.roundNum = 0
	
	GlobalStats.totalGoldEarned = 0
	
	GlobalStats.goldAmount = GlobalStats.defaultGoldAmount
	GlobalStats.staminaCost = 50
	GlobalStats.sturdinessCost = 50
	GlobalStats.spinForceCost = 50
	upgradeUI.set_costs_to_default()
	restart_round_with_random()

func update_player_top_stats():
	set_should_be_counting(false)
	playerTop.update_stats()

func _on_round_end_ui_said_yes() -> void:
	
	upgradeUI.set_hidden(false)
	nextRoundUI.set_hidden(true)
	playerSafetyBarrier.set_disabled_collision(false)
	safetyBarrierCollider.disabled = true
	#opponentStatDictionaryArray = []


func _on_oops_ui_said_yes() -> void:
	_on_prompt_ui_restart_round_said_yes()

func restart_idle_timer() -> void:
	
	shouldBeCounting = true
	timeSinceLastHit = 0.0
	Engine.time_scale = originalTimeScale

func set_should_be_counting(new_value : bool):
	
	shouldBeCounting = new_value
	if(!shouldBeCounting):
		timeSinceLastHit = 0.0

func connect_ui_hidden_signals():
	
	upgradeUI.popped_up.connect(gameTimerUI.set_hidden.bind(true))
	
	#popupUI.popped_up.connect(playerSafetyBarrier.set_disabled_collision.bind(false))
	
	for i in popUpUIArray:
		
		i.popped_up.connect(gameTimerUI.pause_timer)
		
		i.popped_up.connect(playerSafetyBarrier.set_disabled_collision.bind(false))
		
		oopsUI.popped_up.connect(i.set_hidden.bind(true))
		
		i.popped_up.connect(set_should_be_counting.bind(false))
		
func set_spawn_ramp_collision_disabled(new_value : bool):
	
	for i in rampColliderArray:
		
		i.disabled = new_value
	
func quit_game():
	
	get_tree().quit()
