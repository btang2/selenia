extends Area2D

signal minigame_activated
signal minigame_stopped

var player_in_region = false
var player_chatting = false
var fuel_minigame_active = false
var on_cooldown = false
var fuelGame
var hasItems = false
var num_emptytank = 0

func _ready() -> void:
	Global.fuelfill_stage = 0
	$fuelfill_light.energy = 0
	$q_key.visible = false
	$c_key.visible = false
	$chatbox.visible = false
	$equals_key.visible = false
	
	#pause_mode = Node.PAUSE_MODE_PROCESS
	
func _process(delta: float) -> void:
	if (player_in_region):
		$fuelfill_light.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.7
		if (on_cooldown):
			$q_key.visible = false
			$c_key.visible = false
			$waiting_time.visible = true
			var time_remaining = roundi($Timer.time_left)
			if (time_remaining > 0):
				$waiting_time.text = str(time_remaining)
	else:
		$fuelfill_light.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.2
		$waiting_time.visible = false
	
	if (!Global.fuelfill_active):
		if (Input.is_action_just_pressed("chat") && player_in_region && !player_chatting):
			#Open chat
			player_chatting = true
			$c_key.visible = false
			$chatbox.visible = true
			hasItems = Global.search_inv("res://resources/magicfruit.tres") >= 8
			if (hasItems):
				$equals_key.visible = true
			else:
				$equals_key.visible = false
			$Timer.start(0.5)
		elif (Input.is_action_just_pressed("chat") && player_in_region && player_chatting):
			$chatbox.visible = false
			$equals_key.visible = false
			$c_key.visible = true
			player_chatting = false
			$Timer.start(0.5)
		
		if (Input.is_action_just_pressed("fulfill_quest") && player_in_region && hasItems):
			Global.remove_inv("res://resources/magicfruit.tres", 8)
			Global.fuelfill_active = true
			
			$chatbox.visible = false
			$equals_key.visible = false
			$c_key.visible = false
			
			$waiting_time.visible = true
			on_cooldown = true
			$Timer.start(5.5)
			
	else:
		if (Input.is_action_just_pressed("enter_minigame") && player_in_region && fuel_minigame_active == false && !on_cooldown):
			
			#only activate if have >1 emptyfueltank
			num_emptytank = Global.search_inv("res://resources/emptyfueltank.tres")
			if (num_emptytank > 0):
				$chatbox.visible = false
				emit_signal("minigame_activated")
				fuel_minigame_active = true
				fuelGame = preload("res://scenes/fuelfill_minigame.tscn").instantiate()
				get_tree().current_scene.add_child(fuelGame)
				fuelGame.gameOver.connect(_on_game_over)
				
				on_cooldown = true
				$Timer.start(1)
			else:
				$q_key.visible = false
				$chatbox.visible = true
				$chatbox/speech_bubble/input_sprite.texture = Global.texture_emptyfueltank
				$chatbox/speech_bubble/input_text.text = "1x"
			
		elif (Input.is_action_just_pressed("enter_minigame") && fuel_minigame_active == true && !on_cooldown):
			emit_signal("minigame_stopped")
			fuel_minigame_active = false
			if (Global.fuelfill_stage == 4):
				if (Global.search_inv("res://resources/emptyfueltank.tres") > 0):
					Global.remove_inv("res://resources/emptyfueltank.tres", 1)
					Global.add_inv("res://resources/fullfueltank.tres", 1)
			
			fuelGame.queue_free()
			
			$Timer.start(8.5) #game cooldown (before starting next mining game
			on_cooldown = true
	
	
	
	""""if Input.is_action_pressed("enter_mine") and mining_minigame_active == false:
		mining_minigame_active = true
		get_tree().paused = true
	elif Input.is_action_pressed("enter_mine") and mining_minigame_active == true:
		get_tree().paused = false
		mining_minigame_active = false"""

func _on_game_over():
	emit_signal("minigame_stopped")
	fuel_minigame_active = false
	if (Global.fuelfill_stage == 4):
		if (Global.search_inv("res://resources/emptyfueltank.tres") > 0):
			Global.remove_inv("res://resources/emptyfueltank.tres", 1)
			Global.add_inv("res://resources/fullfueltank.tres", 1)
	#TODO as well
	fuelGame.queue_free()
	
	$Timer.start(8.5) #game cooldown (before starting next mining game
	on_cooldown = true
#should be done now: These should all be conditional on the globalvariable 

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_region = true 
		if (Global.fuelfill_active):
			$q_key.visible = true
		else:
			$c_key.visible = true

func _on_body_exited(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_region = false
		$q_key.visible = false
		$c_key.visible = false
		$chatbox.visible = false
		$equals_key.visible = false
		$waiting_time.visible = false
		player_chatting = false


func _on_timer_timeout() -> void:
	if (Global.fuelfill_active):
		on_cooldown = false
		$waiting_time.visible = false
		if (player_in_region):
			$q_key.visible = true
	
