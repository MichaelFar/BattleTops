extends Camera3D

class_name CameraEffects

var originalPosition : Vector3

var isShaking : bool = true

func _ready():
	originalPosition = global_position

func shake_camera():
	
	var rand_obj = RandomNumberGenerator.new()
	
	var shake_strength = .005
		
	global_position = originalPosition + Vector3(randf_range(-shake_strength, shake_strength),
	randf_range(-shake_strength, shake_strength),
	randf_range(-shake_strength, shake_strength))

func set_is_shaking(shake_time : float, current_time : float = 0.0):
	
	var delta_time : float = 0.01
	
	if(current_time > shake_time):
		
		global_position = originalPosition
		return
		
	current_time += delta_time
	
	var timer = get_tree().create_timer(delta_time)
	
	timer.timeout.connect(set_is_shaking.bind(shake_time, current_time))
	
	shake_camera()
	
