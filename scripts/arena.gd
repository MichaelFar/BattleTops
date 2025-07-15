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

var topChildren : Array[BattleTop]

var hasChosenTop : bool = false

func _ready() -> void:
	
	GlobalStats.currentGameStage = GlobalStats.GameStage.CHOOSINGTOP
	
	GlobalStats.currentGameMode = GlobalStats.GameMode.CAREER
	
	popupUI.set_hidden(true)
	
	spawnTimer.timeout.connect(spawn_battle_top)
	upgradeUI.next_round_button_pressed.connect(spawn_battle_top)

func spawn_battle_top():
	
	print("spawning battle top")
	
	for i in spawnMarkerArray.size():
		
		var top_object : BattleTop = battleTopScene.instantiate()
		var rand_obj := RandomNumberGenerator.new()
		
		add_child(top_object)
		top_object.global_position = spawnMarkerArray[i].global_position
		top_object.orientPoint = orientPoint
		topChildren.append(top_object)
		
		top_object.isPlayer = i == 0 && GlobalStats.currentGameMode == GlobalStats.GameMode.CAREER && hasChosenTop
		top_object.shouldBeRandom = !top_object.isPlayer
		#top_object.global_position = spawnMarkerArray[rand_obj.randi_range(0, spawnMarkerArray.size() - 1)].global_position
	
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
	
	numRounds = 1
	
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
			
			if(body.isPlayer):
				
				restartUI.set_hidden(false)
		body.kill_top()
		
func _on_prompt_ui_said_yes() -> void:
	
	popupUI.set_hidden(true)
	
	hasChosenTop = true
	
	var timer = get_tree().create_timer(1.0)
	
	var chosenTop : BattleTop = topChildren[0]
	
	GlobalStats.playerStats["stamina"] = chosenTop.maxStamina
	GlobalStats.playerStats["sturdiness"] = chosenTop.maxSturdiness
	GlobalStats.playerStats["spinForce"] = chosenTop.maxSpinForce
	
	timer.timeout.connect(upgradeUI.set_hidden.bind(false))
	
	
