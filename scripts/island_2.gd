extends Node2D

func _ready() -> void:
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
		
	
	#if (Global.quest_number >= 2):
		#async? I think it's not fully loaded yet
		#print(get_node("./from_" + Global.from_id))
		#get_node(str("./to_island_2")).portal_active = true
		#get_node(str("./to_island_2"))._ready()
		
#this can surely to all scenes non-manually, surely, but will do manual for now
#create class of sorts?
