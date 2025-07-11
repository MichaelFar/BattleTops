extends RigidBody3D

class_name BattleTop

@export var topHead : Node3D

@export var topHeadMesh : MeshInstance3D

@export var physicsMaterial : PhysicsMaterial

@export var headCollision : CollisionShape3D

@export var particle : GPUParticles3D

var stamina : float

var maxStamina : float

var sturdiness : float

var maxSturdiness : float

var spinForce : float

var maxSpinForce : float

var topMeshMaterial : StandardMaterial3D 

var color : Color

var orientPoint : Marker3D

var isDead : bool = false

func _ready():
	
	initialize_values()

func initialize_values():
	
	var rand_obj = RandomNumberGenerator.new()
	
	topMeshMaterial = StandardMaterial3D.new()
	
	topHeadMesh.mesh.surface_set_material(0,topMeshMaterial)
	
	orientPoint = get_parent().orientPoint #CHANGE CHANGE CHANGE CHANGE
	
	spinForce = rand_obj.randf_range(100, 200)
	
	maxSpinForce = spinForce
	
	sturdiness = rand_obj.randf_range(50, 130)
	
	maxSturdiness = sturdiness
	
	maxStamina = rand_obj.randf_range(30, 60)
	
	mass = rand_obj.randf_range(1.0, 3.0)
	
	stamina = maxStamina
	#physicsMaterial.bounce = rand_obj.randf_range(0.0, .75)
	physicsMaterial.friction = 0.0
	
	physics_material_override = physicsMaterial
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "stamina", 0.0, maxStamina)
	
	tween.finished.connect(kill_top)
	
	color = Color(sturdiness / 130,spinForce / 200,stamina / 60)
	
	topMeshMaterial.albedo_color = color
func _physics_process(delta: float) -> void:
	
	if(!isDead):
		
		topHead.look_at(orientPoint.global_position)
		
	topHead.global_position = global_position
	
	particle.emitting = linear_velocity.length() > 3
	
func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if(body is BattleTop && !isDead):
		
		spinForce = ((int(stamina) ^ 2) / maxStamina) * maxSpinForce
		sturdiness = (stamina / maxStamina) * maxSturdiness
		body.apply_central_force(global_position.direction_to(body.global_position) * clampf(spinForce - body.sturdiness, 0.0, spinForce + body.sturdiness))
		stamina += body.spinForce + spinForce
		if(body.isDead):
			stamina = maxStamina
		var tween = get_tree().create_tween()
	
		tween.tween_property(self, "stamina", 0.0, maxStamina * (stamina / maxStamina))

		tween.finished.connect(kill_top)
		
	elif(body is BattleTop):
		apply_central_force(global_position.direction_to(orientPoint.global_position)  * 1000)
		headCollision.disabled = true
func kill_top():
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
