extends Control

signal dialogue_finished
signal quest_completed

var dialogue = []
@export var player_has_required = false
var d_active = false

func _ready():
	$NinePatchRect.visible = false
	
func getSpriteTexture():
	#sadly, hardcoded
	if (Global.quest_number <= 0):
		return Global.texture_magicfruit
	elif (Global.quest_number == 1):
		return Global.texture_metalscrap
	elif (Global.quest_number == 2):
		return Global.texture_fullfueltank #placeholder
	elif (Global.quest_number == 3):
		return Global.texture_enginescrap
	elif (Global.quest_number == 4):
		return Global.texture_solarpanel
	elif (Global.quest_number == 5):
		return Global.texture_spaceship_icon
	else:
		return Global.texture_purpleportalkey
func start():
	if (d_active):
		return
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	#current_dialogue_id = cur_id
	
	if (dialogue[max(Global.quest_number, 0)]["TargetItem"] == "spaceshipicon"):
		$NinePatchRect/TargetItem.text = ""
		$NinePatchRect/Sprite2D.texture = getSpriteTexture()
		$NinePatchRect/Sprite2D.scale = Vector2(0.8, 0.8)
		$NinePatchRect/Sprite2D.offset.x = -10
	else:
		$NinePatchRect/Sprite2D.texture = getSpriteTexture()
		$NinePatchRect/TargetItem.text = str(dialogue[max(Global.quest_number, 0)]["quantity"]) + "x"
		
	#"[center]" + dialogue[max(Global.quest_number, 0)]["TargetItem"] + "[/center]"
	#can't preload non-constant texture :( so have to hardcode
	
	#next_script()


	

func load_dialogue():
	var file = FileAccess.open("res://dialogue/alien_dialogue.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	if (d_active && event.is_action_pressed("fulfill_quest") && player_has_required):
		#change when actually implementing quests, secret button for now
		#next_script()
		emit_signal("quest_completed") #important to keep here for order
		Global.quest_number += 1
		if (dialogue[max(Global.quest_number, 0)]["TargetItem"] == "spaceshipicon"):
			$NinePatchRect/TargetItem.text = ""
			$NinePatchRect/Sprite2D.texture = getSpriteTexture()
			$NinePatchRect/Sprite2D.scale = Vector2(0.8, 0.8)
			$NinePatchRect/Sprite2D.offset.x = -10
		else:
			$NinePatchRect/Sprite2D.texture = getSpriteTexture()
			$NinePatchRect/TargetItem.text = str(dialogue[max(Global.quest_number, 0)]["quantity"]) + "x"
		#$NinePatchRect/TargetItem.text = "[center]" + dialogue[max(Global.quest_number,0)]["TargetItem"] + "[/center]"
		
		
		#d_active = false
		#$NinePatchRect.visible = false
		#maybe change player has required to false -- recomputed anyways

func cancel_dialogue():
	#current_dialogue_id -= 1
	#emit_signal("dialogue_finished")
	d_active = false 
	$NinePatchRect.visible = false
	
