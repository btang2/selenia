extends CanvasModulate

@export var gradient: GradientTexture1D

func _process(delta: float) -> void:
	Global.time += (delta / 30.0)
	var value = (sin(Global.time - PI / 2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
