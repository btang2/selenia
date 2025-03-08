extends CanvasLayer

#IDEALLY: one single spritesheet for all quest icons, and then just change frame

@export var gradient: GradientTexture1D

func _ready():
	update()
	
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
			$npc_icon_sprite.visible = false
			$end_sprite.texture = preload("res://resources/magicfruit.tres").texture
			
			Global.stored_quest_num = Global.quest_number
			Global.quest_part = 1
			
		$quest_progress.value = 100*min(Global.search_inv("res://resources/magicfruit.tres"), 3) / 3.0
	elif (Global.quest_number == 1):	
		if (Global.stored_quest_num != Global.quest_number):
			$start_sprite.visible = true
			$end_sprite.visible = true
			$npc_icon_sprite.visible = false
			
			Global.stored_quest_num = Global.quest_number
			Global.quest_part = 1
		
		#transition
		if (Global.quest_part == 1 && Global.search_inv("res://resources/metalore.tres") >= 12):
			#cooldown of sorts
			Global.quest_part = 2
	
		if (Global.quest_part == 1):
			$start_sprite.texture = preload("res://resources/blueportalkey.tres").texture
			$end_sprite.texture = preload("res://resources/metalore.tres").texture
			$quest_progress.value = 100*min(Global.search_inv("res://resources/metalore.tres"), 12) / 12.0
		elif (Global.quest_part == 2):
			$start_sprite.texture = preload("res://resources/metalore.tres").texture
			$end_sprite.texture = preload("res://resources/metalscrap.tres").texture
			$quest_progress.value = 100*min(Global.search_inv("res://resources/metalscrap.tres"), 2) / 2.0
			
	else:
		$quest_progress.value = 0
		$start_sprite.visible = false
		$end_sprite.visible = false
	#update color
	$quest_progress.modulate = Color(gradient.gradient.sample($quest_progress.value / 100), 0.7)
	
		
	
