extends RigidBody3D

class_name BattleTop

@export var topHead : Node3D

@export var topHeadMesh : MeshInstance3D

@export var physicsMaterial : PhysicsMaterial

@export var headCollision : CollisionShape3D

@export var particle : GPUParticles3D

@export var hitCheckTimer : Timer

@export var hitParticleScene : PackedScene

@export var nameTag : Label3D

enum TopType {NPC, PLAYER}

var stamina : float = 20 :
	set(value):
		stamina = value
		if(stamina <= maxStamina / 3.0):
			has_low_stamina.emit()

var maxStamina : float = 40 :
	set(value):
		maxStamina = value
		if(isPlayer):
			print("Set stamina is now " + str(maxStamina))

var sturdiness : float = 40 

var maxSturdiness : float = 80 :
	set(value):
		maxSturdiness = value
		if(isPlayer):
			print("Set sturdiness is now " + str(maxSturdiness))

var spinForce : float = 100

var maxSpinForce : float = 150 :
	set(value):
		maxSpinForce = value
		if(isPlayer):
			print("Set spin force is now " + str(maxSpinForce))

var topMeshMaterial : StandardMaterial3D 

var color : Color

var orientPoint : Marker3D

var isDead : bool = false

var infiniteStaminaMode : bool = false

var minimumLinearVelocity : float = 1.3

var insideArena : bool = false

var hasBeenHit : bool = false # Forgiveness

var shouldBeRandom : bool = true

var moneyReward : float = 0.0

var currentGameMode : GlobalStats.GameMode : 
	
	set(value):
		
		currentGameMode = value
		
		match value:
			
			GlobalStats.GameMode.SCREENSAVER:
				
				shouldBeRandom = true
	
	get():
	
		return currentGameMode

var staminaTween : Tween :
	
	set(value):
		
		staminaTween = value
		
		if(infiniteStaminaMode):
			
			staminaTween.kill()
			
	get():
		
		return staminaTween
		

var isPlayer : bool = true


var topStats : Dictionary = { #Only checked when score is considered as an opponent
	"stamina" : 20.0,
	"sturdiness" : 40.0,
	"spinForce" : 100.0
}

var staminaIsGoingDown : bool = false

var numTopsDefeated : int = 0

var lastHitTop : BattleTop

signal has_hit_top
signal first_hit_occured
signal has_sparked
signal has_low_stamina

func _ready():
	
	hitCheckTimer.start()
	
	hitCheckTimer.timeout.connect(check_colliding_then_apply_spin_force)
	
	currentGameMode = GlobalStats.currentGameMode
	
	initialize_values()
	
	first_hit_occured.connect(set_stamina_is_going_down.bind(true))
	
func initialize_values():
	
	physicsMaterial.friction = 0.0
	
	physics_material_override = physicsMaterial
	
	topMeshMaterial = StandardMaterial3D.new()
	
	infiniteStaminaMode = GlobalStats.infiniteStaminaMode
	
	
	if(shouldBeRandom):
		
		var rand_obj = RandomNumberGenerator.new()
		
		maxStamina = rand_obj.randf_range(30 + GlobalStats.opponentTopRangeDict["stamina"].x, 60+ GlobalStats.opponentTopRangeDict["sturdiness"].y)
		
		stamina = maxStamina
		
		sturdiness = rand_obj.randf_range(50 + GlobalStats.opponentTopRangeDict["sturdiness"].x, 130 + GlobalStats.opponentTopRangeDict["sturdiness"].y)
		
		maxSturdiness = sturdiness
		
		spinForce = rand_obj.randf_range(100 + GlobalStats.opponentTopRangeDict["spinForce"].x, 200 + GlobalStats.opponentTopRangeDict["spinForce"].x)
		
		maxSpinForce = spinForce
		
		mass = 2
		
		topStats["stamina"] = maxStamina
		topStats["sturdiness"] = maxSturdiness
		topStats["spinForce"] = maxSpinForce
		
		
		#physicsMaterial.bounce = rand_obj.randf_range(0.0, .75)
		print("Generated random stats")
		
	minimumLinearVelocity = randf_range(1.2, minimumLinearVelocity)
	
	color = Color(sturdiness / 130,spinForce / 200,stamina / 60)
		
	topMeshMaterial.albedo_color = color
	
	topHeadMesh.material_override = topMeshMaterial
	
func _physics_process(delta: float) -> void:
	
	if(staminaIsGoingDown):
		stamina -= delta
		stamina = clampf(stamina, 0.0, maxStamina)
	if(!isDead):
		
		topHead.look_at(orientPoint.global_position)
		
	topHead.global_position = global_position
	
	particle.emitting = linear_velocity.length() > 2.5
	
	if(linear_velocity.length() < minimumLinearVelocity && !isDead && insideArena):
		
		linear_velocity = linear_velocity.normalized() * minimumLinearVelocity
		
func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	
	if(body is BattleTop && !isDead):
		
		hit_battle_top(body)
		
	elif(body is BattleTop):
		
		apply_central_force(global_position.direction_to(orientPoint.global_position)  * 100)
		
		#headCollision.disabled = true
		
func kill_top():
	
	print("Top died")
	isDead = true
	physicsMaterial = PhysicsMaterial.new()
	physicsMaterial.friction = 0.0
	physicsMaterial.bounce = 1.0
	mass = 0.0001
	physicsMaterial.absorbent = true
	sturdiness = 0.0
	spinForce = 0.0
	physics_material_override = physicsMaterial
	
	if(lastHitTop != null):
		lastHitTop.numTopsDefeated += 1
	
	var timer = get_tree().create_timer(15.0)
	
	timer.timeout.connect(queue_free)

func check_colliding_then_apply_spin_force():
	
	for i in get_colliding_bodies():
		
		if(i is BattleTop):
			
			hit_battle_top(i)
		
func hit_battle_top(battle_top : BattleTop):
	
	print("Hitting top")
	print("Stamina coefficient before calculating spinforce is " + str(stamina / maxStamina))
	spinForce = clampf((stamina / maxStamina) * maxSpinForce, maxSpinForce / 3.0, 1000)
	print("Spin force is " + str(spinForce))
	
	print("Stamina coefficient before calculating sturdiness is " + str(stamina / maxStamina))
	sturdiness = (stamina / maxStamina) * maxSturdiness
	
	print("Sturdiness during hit is " + str(sturdiness))
	#physicsMaterial.absorbent = !hasBeenHit
	#
	#physics_material_override = physicsMaterial
	#
	
	spawn_hit_particle(battle_top.global_position)
	lastHitTop = battle_top
	if(!hasBeenHit):
		
		first_hit_occured.emit()
		
		hasBeenHit = true
		
	else:
		physicsMaterial.absorbent = false
	
		physics_material_override = physicsMaterial
	
	has_hit_top.emit()
	
	
	
	battle_top.apply_central_force(global_position.direction_to(battle_top.global_position) * clampf(spinForce - (battle_top.sturdiness / 2.0), 0.0, 1000))
	print("Force applied to top is " + str(global_position.direction_to(battle_top.global_position) * clampf(spinForce -battle_top.sturdiness , 0.0, 1000)))
	stamina += battle_top.spinForce + spinForce
	
	stamina = clampf(stamina, 0.0, maxStamina)
	
	if(battle_top.isDead):
	
		stamina = maxStamina
	
	

func update_stats():
	
	hasBeenHit = false
	nameTag.visible = true
	maxStamina = GlobalStats.playerStats["stamina"] 
	maxSturdiness = GlobalStats.playerStats["sturdiness"]
	maxSpinForce = GlobalStats.playerStats["spinForce"]
	stamina = maxStamina
	
func set_stamina_is_going_down(new_value : bool):
	
	staminaIsGoingDown = new_value
	if(!new_value):
		stamina = maxStamina

func spawn_hit_particle(opponent_position : Vector3):
	
	var particle_instance : GPUParticles3D = hitParticleScene.instantiate()
	
	var spawn_position : Vector3 = Vector3((global_position.x + opponent_position.x) / 2,(global_position.y + opponent_position.y) / 2,(global_position.z + opponent_position.z) / 2)
	
	add_child(particle_instance)
	
	particle_instance.one_shot = true
	
	particle_instance.global_position = spawn_position
