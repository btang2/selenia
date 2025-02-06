extends Node2D

func _ready() -> void:
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position

#this can surely to all scenes non-manually, surely, but will do manual for now
#create class of sorts?
