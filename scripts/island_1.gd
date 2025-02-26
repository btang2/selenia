extends Node2D

func _ready() -> void:
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position

#this can surely to all scenes non-manually, surely, but will do manual for now
#create class of sorts?


func _on_mine_minigame_activated() -> void:
	$PlayerCat.can_move = false
	$PlayerCat/PointLight2D.visible = false



func _on_mine_minigame_stopped() -> void:
	$PlayerCat.can_move = true
	$PlayerCat/PointLight2D.visible = true
	#also disable/free the mining_minigame instance? --> done
