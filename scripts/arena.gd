extends Node3D

@export var orientPoint : Marker3D

@export var spawnMarkerArray : Array[Marker3D]

@export var spawnTimer : Timer

@export var battleTopScene : PackedScene

@export var numRounds : int = -1

func _ready() -> void:
	
	spawnTimer.timeout.connect(spawn_battle_top)

func spawn_battle_top():
	
	for i in spawnMarkerArray.size():
		
		var top_object : BattleTop = battleTopScene.instantiate()
		var rand_obj := RandomNumberGenerator.new()
		
		add_child(top_object)
		top_object.global_position = spawnMarkerArray[i].global_position
		top_object.orientPoint = orientPoint
		#top_object.global_position = spawnMarkerArray[rand_obj.randi_range(0, spawnMarkerArray.size() - 1)].global_position
	
	numRounds -= 1
	
	if(numRounds != 0 && spawnTimer.is_stopped()):
		spawnTimer.start()

func _physics_process(delta: float) -> void:
	
	if(Input.is_action_just_released("ui_accept")):
		numRounds  = -1
		spawn_battle_top()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is BattleTop):
		var battle_top : BattleTop = body
		
		
