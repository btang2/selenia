extends Node2D

var t = 0.0

func _ready() -> void:
	#for debug
	#Global.fuelfill_active = true
	t = 0.0
	modulate = Color(0,0,0)
	
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
	if (!Global.fuelfill_active):
		$magicfruits.visible = true
	else:
		$magicfruits.visible = false	
		
	if (Global.portal_23_active):
		$to_island_3.portal_active = true
		$to_island_3._ready()
	if (Global.portal_24_active):
		$to_island_4.portal_active = true
		$to_island_4._ready()
	if (Global.portal_26_active):
		$to_island_6.portal_active = true
		$to_island_6._ready()
		
	
	#if (Global.quest_number >= 2):
		#async? I think it's not fully loaded yet
		#print(get_node("./from_" + Global.from_id))
		#get_node(str("./to_island_2")).portal_active = true
		#get_node(str("./to_island_2"))._ready()
		
#this can surely to all scenes non-manually, surely, but will do manual for now
#create class of sorts?
func _process(delta: float) -> void:
	if (t <= 2):
		modulate = Color(t/2, t/2, t/2)
		t += delta

func _on_fuelfill_minigame_minigame_activated() -> void:
	$PlayerCat.can_move = false
	$PlayerCat/PointLight2D.visible = false
	$inventory_gui.visible = false
	$quest_progress.visible = false
	
	Global.fuelfill_stage = 0


func _on_fuelfill_minigame_minigame_stopped() -> void:
	$PlayerCat.can_move = true
	$PlayerCat/PointLight2D.visible = true
	$inventory_gui.visible = true
	$quest_progress.visible = true
	
