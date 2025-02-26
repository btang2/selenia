extends Node2D

var t = 0.0

func _ready() -> void:
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
	else:
		$move_instruction.visible = true
		#$move_instruction_timer.start(5) #could be better instead to wait until player presses a key
		#Global.player_inv = ["res://resources/magicfruit.tres", "", "", "", "", "", "", ""]
		#Global.player_inv_count = [1, 0, 0, 0, 0, 0, 0, 0]
		#$inventory_gui.update()
	if (Global.quest_number == 0):
		$"magicfruit-1".visible = true
		$"magicfruit-2".visible = true
		$"magicfruit-3".visible = true
	else:
		$"magicfruit-1".visible = false
		$"magicfruit-2".visible = false
		$"magicfruit-3".visible = false
		$to_island_1.portal_active = true
		$to_island_1._ready()
#this can surely to all scenes non-manually, surely, but will do manual for now

func _process(delta: float) -> void:
	if ($move_instruction.visible):
		t += 3*delta
		$move_instruction/W.scale = Vector2(0.01*sin(t) + 0.3, 0.01*sin(t) + 0.3)
		$move_instruction/A.scale = Vector2(0.01*sin(t+0.5) + 0.3, 0.01*sin(t+0.5) + 0.3)
		$move_instruction/S.scale = Vector2(0.01*sin(t+1) + 0.3, 0.01*sin(t+1) + 0.3)
		$move_instruction/D.scale = Vector2(0.01*sin(t+1.5) + 0.3, 0.01*sin(t+1.5) + 0.3)
	
	if (Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down") || Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right")):
		$move_instruction.visible = false
