extends CanvasLayer

func _ready() -> void:
	#reset mining game
	$PlayerCat/PointLight2D.energy = 0.5
	#do other reset actions

func _process(delta: float) -> void:
	var dummy = true
	#if (Input.is_action_just_pressed("enter_mine")):
	#	get_tree().paused = false
	#	get_node("res://scenes/mining_minigame.tscn").queue_free()
