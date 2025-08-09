extends GPUParticles3D

var colorParameter : Color :
	set(value):
		colorParameter = value
		print("Setting particle color")
		draw_pass_1.material.set_shader_parameter("ColorParameter", colorParameter)
