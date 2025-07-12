extends RigidBody3D

class_name BattleTop

@export var topHead : Node3D

@export var topHeadMesh : MeshInstance3D

@export var physicsMaterial : PhysicsMaterial

@export var headCollision : CollisionShape3D

@export var particle : GPUParticles3D

@export var hitCheckTimer : Timer

enum TopType {NPC, PLAYER}

var stamina : float = 20

var maxStamina : float = 40

var sturdiness : float = 40

var maxSturdiness : float = 80

var spinForce : float = 100

var maxSpinForce : float = 150

var topMeshMaterial : StandardMaterial3D 

var color : Color

var orientPoint : Marker3D

var isDead : bool = false

var infiniteStaminaMode : bool = false

var minumumLinearVelocity : float = 2.0

var insideArena : bool = false

var staminaTween : Tween :
	
	set(value):
		
		staminaTween = value
		
		if(infiniteStaminaMode):
			
			staminaTween.kill()
			
	get():
		
		return staminaTween
		
func _ready():
	
	hitCheckTimer.start()
	
	hitCheckTimer.timeout.connect(check_colliding_then_apply_spin_force)
	
	initialize_values()

func initialize_values():
	
	physicsMaterial.friction = 0.0
	
	physics_material_override = physicsMaterial
	
	topMeshMaterial = StandardMaterial3D.new()
	
	infiniteStaminaMode = GlobalStats.infiniteStaminaMode
	
	if(GlobalStats.currentGameMode == GlobalStats.GameMode.SCREENSAVER):
		
		var rand_obj = RandomNumberGenerator.new()
		
		spinForce = rand_obj.randf_range(100, 200)
		
		maxSpinForce = spinForce
		
		sturdiness = rand_obj.randf_range(50, 130)
		
		maxSturdiness = sturdiness
		
		maxStamina = rand_obj.randf_range(30, 60)
		
		mass = rand_obj.randf_range(1.0, 3.0)
		
		minumumLinearVelocity = randf_range(1.0, minumumLinearVelocity)
		
		stamina = maxStamina
		#physicsMaterial.bounce = rand_obj.randf_range(0.0, .75)
		
		
		var tween = get_tree().create_tween()
		
		tween.tween_property(self, "stamina", 0.0, maxStamina)
		
		#tween.finished.connect(kill_top)
		
		staminaTween = tween
		
		color = Color(sturdiness / 130,spinForce / 200,stamina / 60)
		
		topMeshMaterial.albedo_color = color
		
	topHeadMesh.material_override = topMeshMaterial
	
func _physics_process(delta: float) -> void:
	
	if(!isDead):
		
		topHead.look_at(orientPoint.global_position)
		
	topHead.global_position = global_position
	
	particle.emitting = linear_velocity.length() > 3
	
	if(linear_velocity.length() < minumumLinearVelocity && !isDead && insideArena):
		
		linear_velocity = linear_velocity.normalized() * minumumLinearVelocity
		
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
	
	var timer = get_tree().create_timer(15.0)
	
	timer.timeout.connect(queue_free)

func check_colliding_then_apply_spin_force():
	
	for i in get_colliding_bodies():
		
		if(i is BattleTop):
			
			hit_battle_top(i)
		
func hit_battle_top(battle_top : BattleTop):
	
	spinForce = clampf(((int(stamina) ^ 2) / maxStamina) * maxSpinForce, maxSpinForce / 1.5, 100)
		
	sturdiness = (stamina / maxStamina) * maxSturdiness
	
	battle_top.apply_central_force(global_position.direction_to(battle_top.global_position) * clampf(spinForce - battle_top.sturdiness, 0.0, 100))
	
	stamina += battle_top.spinForce + spinForce
	
	if(battle_top.isDead):
	
		stamina = maxStamina
	
	var tween = get_tree().create_tween()

	tween.tween_property(self, "stamina", 0.0, maxStamina * (stamina / maxStamina))

	#tween.finished.connect(kill_top)
	
	staminaTween = tween

func upgrade_stats(addStamina : float, addSturdiness : float, addSpinForce : float):
	
	GlobalStats.playerStats[stamina] += addStamina
	GlobalStats.playerStats[sturdiness] += addSturdiness
	GlobalStats.playerStats[spinForce] += addSpinForce
