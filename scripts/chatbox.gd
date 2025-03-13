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
		return preload("res://resources/magicfruit.tres").texture
	elif (Global.quest_number == 1):
		return preload("res://resources/metalscrap.tres").texture
	elif (Global.quest_number == 2):
		return preload("res://resources/fullfueltank.tres").texture #placeholder
	else:
		return preload("res://resources/purpleportalkey.tres").texture
func start():
	if (d_active):
		return
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	#current_dialogue_id = cur_id
	
	$NinePatchRect/TargetItem.text = str(dialogue[max(Global.quest_number, 0)]["quantity"]) + "x"
	#"[center]" + dialogue[max(Global.quest_number, 0)]["TargetItem"] + "[/center]"
	#can't preload non-constant texture :( so have to hardcode
	$NinePatchRect/Sprite2D.texture = getSpriteTexture()
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
		$NinePatchRect/TargetItem.text = str(dialogue[max(Global.quest_number, 0)]["quantity"]) + "x"
		#$NinePatchRect/TargetItem.text = "[center]" + dialogue[max(Global.quest_number,0)]["TargetItem"] + "[/center]"
		$NinePatchRect/Sprite2D.texture = getSpriteTexture()
		
		#d_active = false
		#$NinePatchRect.visible = false
		#maybe change player has required to false -- recomputed anyways

func cancel_dialogue():
	#current_dialogue_id -= 1
	#emit_signal("dialogue_finished")
	d_active = false 
	$NinePatchRect.visible = false
	

#DO NOT USE (bugged)
func next_script():
	#TODO: add functionality where it only advances if you have the item (inventory type system?)
	Global.quest_number += 1
	
	if (Global.quest_number >= len(dialogue)):
		d_active = false
		$NinePatchRect.visible = false
		#current_dialogue_id = -1 #this definitely does not have the right design atm
		emit_signal("dialogue_finished")
	$NinePatchRect/TargetItem.text = str(dialogue[max(Global.quest_number, 0)]["quantity"]) + "x"
	#$NinePatchRect/TargetItem.text = "[center]" + dialogue[Global.quest_number]["TargetItem"] + "[/center]"
	$NinePatchRect/Sprite2D.texture = getSpriteTexture()
