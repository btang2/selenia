extends Node2D

func _ready() -> void:
	#for debug
	#Global.fuelfill_active = true
	#print("loaded island 3")
	#much more todo (mostly islandfruit/enginescrap mechanic)
	#the .gd script will look ideally same as before
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
	
	if (Global.portal_45_active):
		$to_island_5.portal_active = true
		$to_island_5._ready()
	
	if (Global.island4_fruit1_collected):
		$islandfruit1.visible = false
	if (Global.island4_fruit2_collected):
		$islandfruit2.visible = false
	if (Global.island4_enginescrap_collected):
		$enginescrap.visible = false
	if (Global.island4_npc_traded):
		$npc_island_trader.trade_possible = false
	
	$PlayerCat/PointLight2D.energy = $PlayerCat/PointLight2D.energy * 0.7
	$PlayerCat/PointLight2D.texture_scale = $PlayerCat/PointLight2D.texture_scale * 0.9
	
func _on_islandfruit_1_islandfruit_collected() -> void:
	Global.island4_fruit1_collected = true
	
func _on_islandfruit_2_islandfruit_collected() -> void:
	Global.island4_fruit2_collected = true

func _on_enginescrap_enginescrap_collected() -> void:
	Global.island4_enginescrap_collected = true

func _on_npc_island_trader_unique_trade_completed() -> void:
	Global.island4_npc_traded = true
