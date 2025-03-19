extends Node2D

var t = 0.0
func _ready() -> void:
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
	if (Global.portal_12_active):
		#async? I think it's not fully loaded yet
		#print(get_node("./from_" + Global.from_id))
		$to_island_2.portal_active = true
		$to_island_2._ready()
	
	t = 0.0
	modulate = Color(0,0,0)
		
#this can surely to all scenes non-manually, surely, but will do manual for now
#create class of sorts?
func _process(delta: float) -> void:
	if (t <= 2):
		modulate = Color(t/2, t/2, t/2)
		t += delta

func _on_mine_minigame_activated() -> void:
	$PlayerCat.can_move = false
	$PlayerCat/PointLight2D.visible = false
	$inventory_gui.visible = false
	$quest_progress_bar.visible = false
	



func _on_mine_minigame_stopped() -> void:
	$PlayerCat.can_move = true
	$PlayerCat/PointLight2D.visible = true
	$inventory_gui.visible = true
	$quest_progress_bar.visible = true
	#also disable/free the mining_minigame instance? --> done
