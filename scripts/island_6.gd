extends Node2D

func _ready() -> void:
	#for debug
	#Global.fuelfill_active = true
	#much more todo (mostly islandfruit/enginescrap mechanic)
	#the .gd script will look ideally same as before
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
	
	if (Global.island6_fruit1_collected):
		$islandfruit1.visible = false
	if (Global.island6_fruit2_collected):
		$islandfruit2.visible = false
	if (Global.island6_fruit3_collected):
		$islandfruit3.visible = false
	if (Global.island6_fruit4_collected):
		$islandfruit4.visible = false
	if (Global.island6_fruit5_collected):
		$islandfruit5.visible = false
	if (Global.island6_fruit6_collected):
		$islandfruit6.visible = false

func _on_fixsolarpanel_minigame_activated() -> void:
	$PlayerCat.can_move = false
	$PlayerCat/PointLight2D.visible = false
	$inventory_gui.visible = false
	$quest_progress.visible = false

func _on_fixsolarpanel_minigame_stopped() -> void:
	$PlayerCat.can_move = true
	$PlayerCat/PointLight2D.visible = true
	$inventory_gui.visible = true
	$quest_progress.visible = true


func _on_islandfruit_1_islandfruit_collected() -> void:
	Global.island6_fruit1_collected = true


func _on_islandfruit_2_islandfruit_collected() -> void:
	Global.island6_fruit2_collected = true


func _on_islandfruit_3_islandfruit_collected() -> void:
	Global.island6_fruit3_collected = true


func _on_islandfruit_4_islandfruit_collected() -> void:
	Global.island6_fruit4_collected = true


func _on_islandfruit_5_islandfruit_collected() -> void:
	Global.island6_fruit5_collected = true

func _on_islandfruit_6_islandfruit_collected() -> void:
	Global.island6_fruit6_collected = true
