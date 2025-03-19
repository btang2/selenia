extends CanvasLayer

signal gameOver

var on_game_cooldown = false
var on_key_cooldown = false
var fails = 0 #3 fails & ur out
var succeed = false #current
var multiplier = 1
var rng = RandomNumberGenerator.new()


var input = ""
var game_states = [[0,0,0], [0,0,0], [0,0,0], [0,0,0], [0,0,0], [0,0,0], [0,0,0], [0,0,0], [0,0,0]]

func _ready() -> void:
	
	#why mouse no work anymore?
	$SolarGame.mouse_filter = 2
	$SolarGame/PanelContainer.mouse_filter = 1
	
	$SolarGame/PanelContainer/start_solar.frame = Global.solarpanel_stage + 1
	$SolarGame/PanelContainer/end_solar.frame = Global.solarpanel_stage + 2
	succeed = false
	
	$SolarGame/player_input.text = ""
	
	$SolarGame/PanelContainer/fail_1.scale = Vector2(0.5, 0.5)
	$SolarGame/PanelContainer/fail_2.scale = Vector2(0.5, 0.5)
	$SolarGame/PanelContainer/fail_3.scale = Vector2(0.5, 0.5)
	$SolarGame/PanelContainer/fail_1.self_modulate = Color(0.42, 0.42, 0.42)
	$SolarGame/PanelContainer/fail_2.self_modulate = Color(0.42, 0.42, 0.42)
	$SolarGame/PanelContainer/fail_3.self_modulate = Color(0.42, 0.42, 0.42)
			
	
	#generate game examples: 3 2-digit addition, 3 3-digit subtraction, 3 2-digit multiplication, 15s each
	#make sure subtraction is positive
	for i in range(9):
		if (i < 3):
			#print("add")
			game_states[i][0] = rng.randi_range(11, 99)
			game_states[i][1] = rng.randi_range(11, 99)
			game_states[i][2] = game_states[i][0] + game_states[i][1]
		elif (i < 6):
			#print("sub")
			var a = rng.randi_range(101, 999)
			var b = rng.randi_range(101, 999)
			if (a > b):
				game_states[i][0] = a
				game_states[i][1] = b
				game_states[i][2] = a - b
			else: 
				game_states[i][0] = b
				game_states[i][1] = a
				game_states[i][2] = b - a
		else:
			#print("mult")
			game_states[i][0] = rng.randi_range(11, 49)
			game_states[i][1] = rng.randi_range(11, 49)
			game_states[i][2] = game_states[i][0] * game_states[i][1]
	#start game 0
	
	$SolarGame/Timer.start(20) #extra lee-way

func _process(delta: float) -> void:
	
	if (!on_game_cooldown):
		$SolarGame/current_question.visible = true
		var i = Global.solarpanel_stage
		if (i < 3):
			$SolarGame/current_question.text = str(game_states[i][0]) + " + " + str(game_states[i][1]) + " = ?"
		elif (i < 6):
			$SolarGame/current_question.text = str(game_states[i][0]) + " - " + str(game_states[i][1]) + " = ?"
		else:
			$SolarGame/current_question.text = str(game_states[i][0]) + " x " + str(game_states[i][1]) + " = ?"
			
		if (Global.developer_mode):
			$SolarGame/current_question.text += " " + str(game_states[i][2]) 
			
		$SolarGame/waiting_time.visible = true
		$SolarGame/waiting_time.text = str(floor($SolarGame/Timer.time_left * 10) / 10)
		#current game running [ not sure how to start ]
		
		if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && input != "" && !on_key_cooldown):
			if (input == "enter"):
				print("checking " + $SolarGame/player_input.text) 
				check_answer(int($SolarGame/player_input.text))
			elif (input == "clear"):
				input = ""
				$SolarGame/player_input.text = ""
			elif (len($SolarGame/player_input.text) < 9):
				$SolarGame/player_input.text = $SolarGame/player_input.text + input
			
			on_key_cooldown = true
			$SolarGame/PanelContainer/KeyCooldown.start(0.35)
	else:
		$SolarGame/waiting_time.visible = false
		if ($SolarGame/Timer.time_left > 4.0):
			$SolarGame/current_question.visible = true
			
			if (succeed && Global.solarpanel_stage < 9):
				$SolarGame/PanelContainer/end_solar.frame = Global.solarpanel_stage + 2
			
		else:
			if (succeed && Global.solarpanel_stage >= 9):
				emit_signal("gameOver")
			$SolarGame/current_question.visible = false

func check_answer(player_input_int):
	#update to "checking" state, stop any existing timer
	$SolarGame/Timer.stop()
	on_game_cooldown = true
	
	#Global quest number already known, quest variable stored, just need player input
	var res = player_input_int == game_states[Global.solarpanel_stage][2]
	succeed = res #to let the world know
	
	if (!res):
		#handle fail
		fails += 1
		
		print("failed, input " + str(player_input_int) + " , real answer: " + str(game_states[Global.solarpanel_stage][2]))
		$SolarGame/PanelContainer/fail_1.scale = Vector2(0.5, 0.5)
		$SolarGame/PanelContainer/fail_2.scale = Vector2(0.5, 0.5)
		$SolarGame/PanelContainer/fail_3.scale = Vector2(0.5, 0.5)
		$SolarGame/PanelContainer/fail_1.self_modulate = Color(0.42, 0.42, 0.42)
		$SolarGame/PanelContainer/fail_2.self_modulate = Color(0.42, 0.42, 0.42)
		$SolarGame/PanelContainer/fail_3.self_modulate = Color(0.42, 0.42, 0.42)
			
		if (fails >= 1):
			$SolarGame/PanelContainer/fail_1.scale = Vector2(0.6, 0.6)
			$SolarGame/PanelContainer/fail_1.self_modulate = Color(1, 0.42, 0.42)
		if (fails >= 2):
			$SolarGame/PanelContainer/fail_2.scale = Vector2(0.6, 0.6)
			$SolarGame/PanelContainer/fail_2.self_modulate = Color(1, 0.42, 0.42)	
		if (fails >= 3):
			$SolarGame/PanelContainer/fail_3.scale = Vector2(0.6, 0.6)
			$SolarGame/PanelContainer/fail_3.self_modulate = Color(1, 0.42, 0.42)	
			
		#handle 3 failures (wait no handle that on timer timeout), also if fail, regenerate specific example
	else:
		#handle success
		Global.solarpanel_stage += 1
		
		$SolarGame/PanelContainer/start_solar.frame = Global.solarpanel_stage + 1
		
		#handle endstage / success on timeout
	
	$SolarGame/Timer.start(5) #cooldown
	
func _on_timer_timeout() -> void:
	if (!on_game_cooldown):
		check_answer(int($SolarGame/player_input.text))
		
	else:
		var i = Global.solarpanel_stage
		if (succeed):
			if (Global.solarpanel_stage >= 9):
				emit_signal("gameOver")
			else:
				$SolarGame/PanelContainer/end_solar.frame = Global.solarpanel_stage + 2
		else:
			#gotta regenerate 
			if (fails >= 3):
				emit_signal("gameOver")
			else:
				if (i < 3):
					game_states[i][0] = rng.randi_range(11, 99)
					game_states[i][1] = rng.randi_range(11, 99)
					game_states[i][2] = game_states[i][0] + game_states[i][1]
				elif (i < 6):
					#print("sub")
					var a = rng.randi_range(101, 999)
					var b = rng.randi_range(101, 999)
					if (a > b):
						game_states[i][0] = a
						game_states[i][1] = b
						game_states[i][2] = a - b
					else: 
						game_states[i][0] = b
						game_states[i][1] = a
						game_states[i][2] = b - a
				else:
					#print("mult")
					game_states[i][0] = rng.randi_range(11, 49)
					game_states[i][1] = rng.randi_range(11, 49)
					game_states[i][2] = game_states[i][0] * game_states[i][1]
			
		#reset variables & set next timer
		succeed = false
		on_game_cooldown = false
		$SolarGame/player_input.text = ""
		multiplier = 1 + 0.25 * fails #to be a bit more generous
		if (i < 3):
			$SolarGame/Timer.start(10 * multiplier)
		elif (i < 6):
			$SolarGame/Timer.start(15 * multiplier)
		else:
			$SolarGame/Timer.start(20 * multiplier)

func _on_key_cooldown_timeout() -> void:
	on_key_cooldown = false
	

#man. i could not figure out a better working option.

func _on_zero_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/zero_key.modulate = Color(0.9, 0.9, 0.9)
	input = "0"

func _on_zero_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/zero_key.modulate = Color(1, 1, 1)
	input = ""

func _on_one_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/one_key.modulate = Color(0.9, 0.9, 0.9)
	input = "1"

func _on_one_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/one_key.modulate = Color(1, 1, 1)
	input = ""
	

func _on_two_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/two_key.modulate = Color(0.9, 0.9, 0.9)
	input = "2"

func _on_two_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/two_key.modulate = Color(1, 1, 1)
	input = ""

func _on_three_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/three_key.modulate = Color(0.9, 0.9, 0.9)
	input = "3"

func _on_three_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/three_key.modulate = Color(1, 1, 1)
	input = ""

func _on_four_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/four_key.modulate = Color(0.9, 0.9, 0.9)
	input = "4"

func _on_four_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/four_key.modulate = Color(1, 1, 1)
	input = ""


func _on_five_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/five_key.modulate = Color(0.9, 0.9, 0.9)
	input = "5"

func _on_five_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/five_key.modulate = Color(1, 1, 1)
	input = ""

func _on_six_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/six_key.modulate = Color(0.9, 0.9, 0.9)
	input = "6"

func _on_six_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/six_key.modulate = Color(1, 1, 1)
	input = ""

func _on_seven_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/seven_key.modulate = Color(0.9, 0.9, 0.9)
	input = "7"

func _on_seven_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/seven_key.modulate = Color(1, 1, 1)
	input = ""

func _on_eight_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/eight_key.modulate = Color(0.9, 0.9, 0.9)
	input = "8"

func _on_eight_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/eight_key.modulate = Color(1, 1, 1)
	input = ""

func _on_nine_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/nine_key.modulate = Color(0.9, 0.9, 0.9)
	input = "9"

func _on_nine_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/nine_key.modulate = Color(1, 1, 1)
	input = ""

func _on_enter_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/enter_key.modulate = Color(0.9, 0.9, 0.9)
	input = "enter"

func _on_enter_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/enter_key.modulate = Color(1, 1, 1)
	input = ""

func _on_clear_key_mouse_entered() -> void:
	$SolarGame/PanelContainer/clear_key.modulate = Color(0.9, 0.9, 0.9)
	input = "clear"

func _on_clear_key_mouse_exited() -> void:
	$SolarGame/PanelContainer/clear_key.modulate = Color(1, 1, 1)
	input = ""
