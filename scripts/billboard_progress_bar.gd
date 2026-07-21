
extends ProgressBar

# The 3D character whose health this bar represents
@export var topObject : BattleTop
# Camera to calculate screen-space position
var camera: Camera3D

var staminaRatio : float = 1.0 :
	set(new_stam_value):
		staminaRatio = new_stam_value
		value = staminaRatio

func _ready():
	# Get the active camera
	camera = get_viewport().get_camera_3d()
	
	set_visibility(false)
	# Set the initial value to a placeholder (e.g., full health)
	

func initialize():
	topObject.first_hit_occured.connect(set_visibility.bind(true))
	GlobalStats.round_ended.connect(set_visibility.bind(false))
	staminaRatio = topObject.stamina / topObject.maxStamina

func _process(delta):
	staminaRatio = topObject.stamina / topObject.maxStamina
	if not topObject or not camera:
		return
	
	# Update health bar value
	var screen_pos = camera.unproject_position(topObject.global_position + Vector3(0, 0.2, 0))
	global_position = screen_pos
	#  you can adjust the position for visual clarity
	global_position += Vector2(-get_rect().size.x / 2, 0)
	var distance = camera.global_transform.origin.distance_to(topObject.global_transform.origin)
	var scale_factor = clamp(1.0 - distance / 100.0, 0.11, 2.0)
	scale = Vector2(scale_factor, scale_factor)

func set_visibility(new_value : bool):
	visible = new_value
