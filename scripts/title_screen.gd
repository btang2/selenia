extends Node2D

var mouse_in_region = false
var on_cooldown = false

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("down") || Input.is_action_just_pressed("up") ||  Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right")):
		$move_instruction.visible = false
		
	if (!on_cooldown && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && mouse_in_region):
		if ($CanvasGroup/Area2D/Togglemusic.frame == 1):
			$CanvasGroup/Area2D/Togglemusic.frame = 0
			Bgmusic.volume_db = -15
			Bgmusic.stream_paused = false
			$CanvasGroup/Timer.start(0.3)
			on_cooldown = true
			
		else:
			$CanvasGroup/Area2D/Togglemusic.frame = 1
			Bgmusic.volume_db = -1000
			Bgmusic.stream_paused = true
			$CanvasGroup/Timer.start(0.3)
			on_cooldown = true

func _on_area_2d_mouse_entered() -> void:
	$CanvasGroup/Area2D.modulate = Color(0.95, 0.95, 0.95)
	mouse_in_region = true
	

func _on_area_2d_mouse_exited() -> void:
	$CanvasGroup/Area2D.modulate = Color(0.6, 0.6, 0.6)
	mouse_in_region = false


func _on_timer_timeout() -> void:
	on_cooldown = false
