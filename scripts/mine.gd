extends Area2D


signal minigame_activated
signal minigame_stopped

var player_in_region = false
var mining_minigame_active = false
var on_cooldown = false
var miningGame

func _ready() -> void:
	$mine_light.energy = 0
	$q_key.visible = false
	#pause_mode = Node.PAUSE_MODE_PROCESS
	
func _process(delta: float) -> void:
	if (player_in_region):
		$mine_light.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.7
		if (on_cooldown):
			$q_key.visible = false
			$waiting_time.visible = true
			var time_remaining = roundi($Timer.time_left)
			if (time_remaining > 0):
				$waiting_time.text = str(time_remaining)
	else:
		$mine_light.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.2
		$waiting_time.visible = false
	
	if (Input.is_action_just_pressed("enter_mine") && player_in_region && mining_minigame_active == false && !on_cooldown):
		emit_signal("minigame_activated")
		mining_minigame_active = true
		miningGame = preload("res://scenes/mining_minigame.tscn").instantiate()
		get_tree().current_scene.add_child(miningGame)
		
		on_cooldown = true
		$Timer.start(1)
		
	elif (Input.is_action_just_pressed("enter_mine") && mining_minigame_active == true && !on_cooldown):
		emit_signal("minigame_stopped")
		mining_minigame_active = false
		#handle ore gained in inventory
		if (Global.ore_mined > 0):
			Global.add_inv("res://resources/metalore.tres", Global.ore_mined)
		
		
		miningGame.queue_free()
		
		$Timer.start(10.5) #game cooldown (before starting next mining game
		on_cooldown = true
		
	
	
	
	
	""""if Input.is_action_pressed("enter_mine") and mining_minigame_active == false:
		mining_minigame_active = true
		get_tree().paused = true
	elif Input.is_action_pressed("enter_mine") and mining_minigame_active == true:
		get_tree().paused = false
		mining_minigame_active = false"""

		


func _on_body_entered(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_region = true 
		$q_key.visible = true


func _on_body_exited(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_region = false
		$q_key.visible = false
		$waiting_time.visible = false


func _on_timer_timeout() -> void:
	on_cooldown = false
	$waiting_time.visible = false
	if (player_in_region):
		$q_key.visible = true
	
