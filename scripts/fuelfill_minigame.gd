extends CanvasLayer

signal gameOver

var on_game_cooldown = false
var t = 0.0
var arrow_rot = -85.0 #should be linear between -85 and 85
var sgn = 1 #increasing/decreasing
var fails = 0 #3 fails & ur out
var succeed = false #current
var multiplier = 1

func _ready() -> void:
	$FuelGame/PanelContainer/start_fuel.frame = Global.fuelfill_stage
	$FuelGame/PanelContainer/end_fuel.frame = Global.fuelfill_stage + 1
	t = 0.0
	succeed = false
	
	$FuelGame/PanelContainer/fail_1.scale = Vector2(0.4, 0.4)
	$FuelGame/PanelContainer/fail_2.scale = Vector2(0.4, 0.4)
	$FuelGame/PanelContainer/fail_3.scale = Vector2(0.4, 0.4)
	$FuelGame/PanelContainer/fail_1.self_modulate = Color(0.42, 0.42, 0.42)
	$FuelGame/PanelContainer/fail_2.self_modulate = Color(0.42, 0.42, 0.42)
	$FuelGame/PanelContainer/fail_3.self_modulate = Color(0.42, 0.42, 0.42)
			

func _process(delta: float) -> void:
	t += 3*delta
	$FuelGame/PanelContainer/TimingArrow.rotation_degrees = arrow_rot
	$FuelGame/PanelContainer/f_key.scale = Vector2(0.05*sin(t) + 0.4, 0.05*sin(t) + 0.4)
	
	multiplier = 1 + Global.fuelfill_stage
	if (!on_game_cooldown):
		$FuelGame/PanelContainer/f_key.visible = true 
		if (arrow_rot > 85.0):
			sgn = -1
		if (arrow_rot < -85.0):
			sgn = 1
		arrow_rot += 80 * sgn * delta * multiplier # might need more
		
		if (Input.is_action_just_pressed("collect")):
			on_game_cooldown = true
			if (abs(arrow_rot) < 9):
				succeed = true
				if (Global.fuelfill_stage <= 3):
					Global.fuelfill_stage += 1
				$FuelGame/PanelContainer/start_fuel.frame = Global.fuelfill_stage
			else:
				fails += 1
			$FuelGame/Timer.start(4)
		
	else:
		$FuelGame/PanelContainer/f_key.visible = false #some sinusoidal modulate would work too
		if ($FuelGame/Timer.time_left <= 2.5):
			$FuelGame/PanelContainer/TimingArrow.visible = false
			arrow_rot = -85.0
			
			if (succeed):
				if (Global.fuelfill_stage == 4):
					emit_signal("gameOver")
				else:
					$FuelGame/PanelContainer/end_fuel.frame = Global.fuelfill_stage + 1
			if (fails >= 3):
				#exit
				emit_signal("gameOver")
			
		else:
			#update failures
			#defaults
			$FuelGame/PanelContainer/fail_1.scale = Vector2(0.4, 0.4)
			$FuelGame/PanelContainer/fail_2.scale = Vector2(0.4, 0.4)
			$FuelGame/PanelContainer/fail_3.scale = Vector2(0.4, 0.4)
			$FuelGame/PanelContainer/fail_1.self_modulate = Color(0.42, 0.42, 0.42)
			$FuelGame/PanelContainer/fail_2.self_modulate = Color(0.42, 0.42, 0.42)
			$FuelGame/PanelContainer/fail_3.self_modulate = Color(0.42, 0.42, 0.42)
			
			if (fails >= 1):
				$FuelGame/PanelContainer/fail_1.scale = Vector2(0.5, 0.5)
				$FuelGame/PanelContainer/fail_1.self_modulate = Color(1, 0.42, 0.42)
			if (fails >= 2):
				$FuelGame/PanelContainer/fail_2.scale = Vector2(0.5, 0.5)
				$FuelGame/PanelContainer/fail_2.self_modulate = Color(1, 0.42, 0.42)	
			if (fails >= 3):
				$FuelGame/PanelContainer/fail_3.scale = Vector2(0.5, 0.5)
				$FuelGame/PanelContainer/fail_3.self_modulate = Color(1, 0.42, 0.42)	
			


func _on_timer_timeout() -> void:
	on_game_cooldown = false
	$FuelGame/PanelContainer/TimingArrow.visible = true
	$FuelGame/PanelContainer/f_key.visible = true
		
