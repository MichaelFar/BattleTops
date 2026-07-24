extends GPUParticles3D

var textString : String = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_text(new_text : String):
	textString = new_text

func play():
	emitting = true
