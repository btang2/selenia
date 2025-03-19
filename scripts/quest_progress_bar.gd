extends CanvasLayer

#IDEALLY: one single spritesheet for all quest icons, and then just change frame

@export var gradient: GradientTexture1D

func _ready():
	$cur_island_sprite.texture = load_sign(Global.cur_island)
	update()

func load_sign(str):
	if (str == "spawn_island"):
		return Global.texture_sign_s #.texture
	elif (str == "island_1"):
		return Global.texture_sign_1 #.texture
	elif (str == "island_2"):
		return Global.texture_sign_2 #.texture
	elif (str == "island_3"):
		return Global.texture_sign_3 #.texture
	elif (str == "island_4"):
		return Global.texture_sign_4 #.texture
	elif (str == "island_5"):
		return Global.texture_sign_5 #.texture
	elif (str == "island_6"):
		return Global.texture_sign_6 #.texture
#could save on memory if all preloaded on _ready_ instead of always during process	

func _process(delta: float) -> void:
	var value = (sin(Global.time - PI / 2) + 1.0) / 2.0
	$bg.modulate = Color(0.2 + 0.3*(value), 0.2 + 0.3*(value), 0.2 + 0.3*(value), 0.75)
	update() #technically not necessary if inventory doesn't change
	#pass
	#if (Input.is_action_just_pressed("i")):
	#	self.visible = !self.visible #disable later to be always on

func update():
	#print("updating quest") #unfortunately might have to be hard-coded
	#SHOULD only update sprites if necessary
	if (Global.quest_number == -1):
		visible = false
	elif (Global.quest_number == 0):
		visible = true
		if (Global.stored_quest_num != Global.quest_number):
			$start_sprite.visible = false
			$end_sprite.visible = true
			$end_sprite.texture = Global.texture_magicfruit
			$goal_island_sprite.texture = load_sign("spawn_island")
			Global.stored_quest_num = Global.quest_number
			Global.quest_part = 1
		$quest_progress.value = 100*min(Global.search_inv("res://resources/magicfruit.tres"), 3) / 3.0
	elif (Global.quest_number == 1):	
		if (Global.stored_quest_num != Global.quest_number):
			$start_sprite.visible = true
			$end_sprite.visible = true
			$goal_island_sprite.texture = load_sign("island_1")
			Global.stored_quest_num = Global.quest_number
			Global.quest_part = 1
			
		$goal_island_sprite.texture = load_sign("island_1")
		#transition
		if (Global.quest_part == 1 && 6 * Global.search_inv("res://resources/metalscrap.tres") + Global.search_inv("res://resources/metalore.tres") >= 12):
			#cooldown of sorts
			Global.quest_part = 2
	
		if (Global.quest_part == 1):
			$start_sprite.texture = Global.texture_blueportalkey
			$end_sprite.texture = Global.texture_metalore
			$quest_progress.value = 100*min(6 * Global.search_inv("res://resources/metalscrap.tres") + Global.search_inv("res://resources/metalore.tres"), 12) / 12.0
		elif (Global.quest_part == 2):
			$start_sprite.texture = Global.texture_metalore
			$end_sprite.texture = Global.texture_metalscrap
			$quest_progress.value = 100*min(Global.search_inv("res://resources/metalscrap.tres"), 2) / 2.0
	
	elif (Global.quest_number == 2):
		if (Global.stored_quest_num != Global.quest_number):
			$start_sprite.visible = true
			$end_sprite.visible = true
			Global.stored_quest_num = Global.quest_number
			Global.quest_part = 1
		#less guidance, as further on in game
		if (Global.portal_12_active == false):
			$start_sprite.texture = Global.texture_redportalkey
		else:
			$start_sprite.texture = Global.texture_metalore
		$end_sprite.texture = Global.texture_fullfueltank
		
		$goal_island_sprite.texture = load_sign("island_2")
		
		var fulltanks = Global.search_inv("res://resources/fullfueltank.tres")
		var emptytanks = Global.search_inv("res://resources/emptyfueltank.tres")
		var scraps = Global.search_inv("res://resources/metalscrap.tres")
		
		if (fulltanks > 0):
			$quest_progress.value = 60 + 40*min(fulltanks, 3) / 3.0
		elif (emptytanks > 0):
			$quest_progress.value = 30 + 30*min(emptytanks, 3) / 3.0
		else:
			$quest_progress.value = 30*min(scraps, 6) / 6.0
	elif (Global.quest_number == 3):
		if (Global.stored_quest_num != Global.quest_number):
			$start_sprite.visible = true
			$end_sprite.visible = true
			
			Global.stored_quest_num = Global.quest_number
			Global.quest_part = 1
		if (Global.portal_23_active == false):
			$start_sprite.texture = Global.texture_blueportalkey
		else:
			$start_sprite.texture = Global.texture_islandfruit
		$end_sprite.texture = Global.texture_enginescrap
		
		var scraps = min(Global.search_inv("res://resources/enginescrap.tres"), 3)
		
		if (scraps < 1):
			$goal_island_sprite.texture = load_sign("island_3")
		elif (scraps < 2):
			$goal_island_sprite.texture = load_sign("island_4")
		else:
			$goal_island_sprite.texture = load_sign("island_5")
		
		$quest_progress.value = 100 * min(scraps, 3) / 3.0
	elif (Global.quest_number == 4):
		if (Global.stored_quest_num != Global.quest_number):
			$start_sprite.visible = true
			$end_sprite.visible = true
			
			Global.stored_quest_num = Global.quest_number
			Global.quest_part = 1
			
		if (Global.quest_part == 1 && Global.search_inv("res://resources/solarpanelscrap.tres") >= 2):
			Global.quest_part = 2
		
		if (Global.quest_part == 1):
			if (Global.portal_26_active == false):
				$start_sprite.texture = Global.texture_purpleportalkey
			else:
				$start_sprite.texture = Global.texture_emptyfueltank
			
			$goal_island_sprite.texture = load_sign("island_2")
			
			var fullfueltanks = Global.search_inv("res://resources/fullfueltank.tres")
			var solarpanelscraps = Global.search_inv("res://resources/solarpanelscrap.tres")
			
			if (fullfueltanks > 0):
				$end_sprite.texture = Global.texture_solarpanelscrap
			else:
				$end_sprite.texture = Global.texture_fullfueltank
			
			if (solarpanelscraps > 0):
				$quest_progress.value = 50 + 50 * min(Global.search_inv("res://resources/solarpanelscrap.tres"), 2) / 2.0
			elif (fullfueltanks > 0):
				$quest_progress.value = 30 + 20 * min(Global.search_inv("res://resources/fullfueltank.tres"), 4) / 4.0
			else:
				$quest_progress.value = 30 * min(Global.search_inv("res://resources/emptyfueltank.tres"), 4) / 4.0
			
		elif (Global.quest_part == 2):
			$start_sprite.texture = Global.texture_solarpanelscrap
			$end_sprite.texture = Global.texture_solarpanel
			$goal_island_sprite.texture = load_sign("island_6")
			var solarpanels = Global.search_inv("res://resources/solarpanel.tres")
			if (solarpanels > 0):
				$quest_progress.value = 50 + 50 * min(solarpanels, 2) / 2.0
			else:
				$quest_progress.value = 50 * min(Global.search_inv("res://resources/solarpanelbroken.tres"), 2) / 2.0
	elif (Global.quest_part == 5):
		$start_sprite.visible = false
		$end_sprite.texture = Global.texture_spaceship_icon
		$goal_island_sprite.texture = load_sign("spawn_island")
	else:
		$quest_progress.value = 0
		$start_sprite.visible = false
		$end_sprite.visible = false
	#update color
	$quest_progress.modulate = Color(gradient.gradient.sample($quest_progress.value / 100), 0.7)
	
		
	
