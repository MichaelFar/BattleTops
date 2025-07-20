extends StaticBody3D

class_name PlayerSafetyBarrier

var collisionChildren := []

@export_flags_3d_physics var player_collision_mask

func _ready():
	
	collisionChildren = get_collision_children()
	set_disabled_collision(true)

func get_collision_children() -> Array:
	
	var returned_array := []
	
	for i in get_children():
		
		if(i is CollisionShape3D):
			returned_array.append(i)
	
	return returned_array

func set_disabled_collision(new_value : bool):
	
	for i in collisionChildren:
		
		i.disabled = new_value
