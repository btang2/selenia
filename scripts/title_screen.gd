extends Node2D

var mouse_in_play_region = false
var mouse_in_volume_region = false
var on_cooldown = false
var transition_scene_active = false

func _ready() -> void:
	#reset EVERYTHING. global
	Global.from_id = "" #default, change if not from somewhere, use when instantiating maps
	Global.cur_island = "spawn_island"
	#both should be initialized upon spawn
	Global.player_inv = ["", "", "", "", "", "", "", ""] #global record of player inventory
	Global.player_inv_count = [0, 0, 0, 0, 0, 0, 0, 0] #global record of player inventory count (how much each item)
	Global.quest_number = -1 #before discovering alien
	Global.quest_part = 1 #for quests with multiple parts
	Global.stored_quest_num = -1 #to track changes in quest

	#portal transitions; only have to do half (s1, 1s governed by same variable)
	Global.portal_s1_active = false
	Global.portal_12_active = false

	Global.portal_23_active = false
	Global.portal_24_active = false
	Global.portal_45_active = false

	Global.portal_26_active = false

	Global.time = 0 #start out midnight

	#mine (island 1)
	Global.ore_mined = 0 #global variable for mining minigame
	Global.mining_cooldown = 0.25 #for mining (default 0.25), ideally exchange ore for pickaxe to reduce this
	Global.ore_prob = 0.05 #probability a given stone block is actually ore (for generating map)
	#expected = 24*13*ore_prob (=0.05) ~ expected 15.6 ores per game

	#(island 2) should give compass that tracks these things (for island 345?)
	Global.fuelfill_active = false #needs 8 magicfruit
	Global.fuelfill_stage = 0 #needs to get to 3 to fill

	#(island 3) store already collected items
	Global.island3_fruit1_collected = false
	Global.island3_fruit2_collected = false
	Global.island3_fruit3_collected = false
	Global.island3_enginescrap_collected = false
	Global.island3_npc_traded = false

	#(island 4)
	Global.island4_fruit1_collected = false
	Global.island4_fruit2_collected = false
	Global.island4_enginescrap_collected = false
	Global.island4_npc_traded = false

	#(island 5)
	Global.island5_fruit1_collected = false
	Global.island5_fruit2_collected = false
	Global.island5_fruit3_collected = false
	Global.island5_fruit4_collected = false
	Global.island5_fruit5_collected = false
	Global.island5_npc_traded = false

	#(island 6)
	Global.island6_fruit1_collected = false
	Global.island6_fruit2_collected = false
	Global.island6_fruit3_collected = false
	Global.island6_fruit4_collected = false
	Global.island6_fruit5_collected = false
	Global.island6_fruit6_collected = false

	Global.solar_game_active = false
	Global.solarpanel_stage = 0

	Global.spaceship_stage = 0

func _process(delta: float) -> void:
	$spaceship/AnimationPlayer.play("spaceship_active")
	if (!transition_scene_active):
		if (!on_cooldown && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			if (mouse_in_volume_region):
				if ($Area2D/Togglemusic.frame == 1):
					$Area2D/Togglemusic.frame = 0
					Bgmusic.volume_db = -15
					Bgmusic.stream_paused = false
					$Timer.start(0.3)
					on_cooldown = true
					
				else:
					$Area2D/Togglemusic.frame = 1
					Bgmusic.volume_db = -1000
					Bgmusic.stream_paused = true
					$Timer.start(0.3)
					on_cooldown = true
			if (mouse_in_play_region):
				$TransitionTimer.start(12)
				transition_scene_active = true
				$spaceship/PointLight2D.energy = 1.25
				$Camera2D.enabled = true
				
	else:
		if ($TransitionTimer.time_left >= 10):
			var i = ($TransitionTimer.time_left - 10) / 2
			$base_ground.modulate = Color(i,i,i)
			$TItle.modulate = Color(i,i,i)
			$Play.modulate = Color(i,i,i)
			$Area2D.modulate = Color(i,i,i)
		if ($TransitionTimer.time_left < 10):
			
			$spaceship.position.x += 80*delta
			
			#camera shake & fade out
			if ($TransitionTimer.time_left < 7 && $TransitionTimer.time_left >= 4):
				$spaceship/Base.frame = 2
				$spaceship/Shield.visible = false
			if ($TransitionTimer.time_left < 4):
				$spaceship/Engineflames.visible = false
				$spaceship/Engine.visible = false
				$spaceship/Base.frame = 3
				#camera shake
				var dx = RandomNumberGenerator.new().randf_range(-1, 1)
				var dy = RandomNumberGenerator.new().randf_range(-1, 1)
				$Camera2D.offset = Vector2(dx, dy) * ($TransitionTimer.time_left + 0.5) * 3
				
				$spaceship.global_rotation_degrees = 125
			if ($TransitionTimer.time_left < 2):
				modulate = Color($TransitionTimer.time_left/2, $TransitionTimer.time_left/2, $TransitionTimer.time_left/2)

func _on_area_2d_mouse_entered() -> void:
	$Area2D.modulate = Color(0.95, 0.95, 0.95)
	$Area2D/PointLight2D.energy = 1.5
	mouse_in_volume_region = true
	

func _on_area_2d_mouse_exited() -> void:
	$Area2D.modulate = Color(0.8, 0.8, 0.8)
	$Area2D/PointLight2D.energy = 1.0
	mouse_in_volume_region = false


func _on_timer_timeout() -> void:
	on_cooldown = false


func _on_play_mouse_entered() -> void:
	$Play.modulate = Color(0.95, 0.95, 0.95)
	$Play/PointLight2D.energy = 1.5
	mouse_in_play_region = true


func _on_play_mouse_exited() -> void:
	$Play.modulate = Color(0.8, 0.8, 0.8)
	$Play/PointLight2D.energy = 1.0
	mouse_in_play_region = false


func _on_transition_timer_timeout() -> void:
	Global.from_id = ""
	var new_scn = "res://scenes/spawn_island.tscn"
	get_tree().change_scene_to_file(new_scn)
