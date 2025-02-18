extends Node2D


func _ready() -> void:
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
	else:
		$move_instruction.visible = true
		$move_instruction_timer.start(2.5) #could be better instead to wait until player presses a key
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
#this can surely to all scenes non-manually, surely, but will do manual for now


func _on_move_instruction_timer_timeout() -> void:
	$move_instruction_timer.stop()
	$move_instruction.visible = false
	#purely a test
	#Global.player_inv[1] = "res://resources/magicfruit.tres"
	#Global.player_inv_count[0] += 1
	#Global.player_inv_count[1] += 1
