extends Control

signal dialogue_finished


var dialogue = []
@export var current_dialogue_id = 0
var d_active = false

func _ready():
	$NinePatchRect.visible = false
	
func start(cur_id):
	if (d_active):
		return
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = cur_id
	next_script()
	

func load_dialogue():
	var file = FileAccess.open("res://dialogue/alien_dialogue.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	if (d_active && event.is_action_pressed("ui_accept")):
		#change when actually implementing quests, secret button for now
		next_script()

func cancel_dialogue():
	current_dialogue_id -= 1
	#emit_signal("dialogue_finished")
	d_active = false 
	$NinePatchRect.visible = false
	
func next_script():
	#TODO: add functionality where it only advances if you have the item (inventory type system?)
	current_dialogue_id += 1
	
	if (current_dialogue_id >= len(dialogue)):
		d_active = false
		$NinePatchRect.visible = false
		current_dialogue_id = -1 #this definitely does not have the right design atm
		emit_signal("dialogue_finished")
	$NinePatchRect/TargetItem.text = "[center]" + dialogue[current_dialogue_id]["TargetItem"] + "[/center]"
