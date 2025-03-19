extends Node2D

var on_zoom_cooldown = false
var zoom_active = false
var t = 0.0

func _ready() -> void:
	#for debug
	#Global.fuelfill_active = true
	#much more todo (mostly islandfruit/enginescrap mechanic)
	#the .gd script will look ideally same as before
	t = 0.0
	modulate = Color(0,0,0)
	
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
	
	if (Global.island5_fruit1_collected):
		$islandfruit1.visible = false
	if (Global.island5_fruit2_collected):
		$islandfruit2.visible = false
	if (Global.island5_fruit3_collected):
		$islandfruit3.visible = false
	if (Global.island5_fruit4_collected):
		$islandfruit4.visible = false
	if (Global.island5_fruit5_collected):
		$islandfruit5.visible = false
	if (Global.island5_npc_traded):
		$npc_island_trader.trade_possible = false
	
	$PlayerCat/PointLight2D.energy = $PlayerCat/PointLight2D.energy * 0.7
	$PlayerCat/PointLight2D.texture_scale = $PlayerCat/PointLight2D.texture_scale * 0.9
	

func _process(delta: float) -> void:
	if (t <= 2):
		modulate = Color(t/2, t/2, t/2)
		t += delta
	if (!on_zoom_cooldown):
		$zoom_key.visible = true
		$zoom_key.scale = Vector2(0.25 + 0.03*sin(2*60*Global.time), 0.25 + 0.03*sin(2*60*Global.time))
		
		if (Input.is_action_just_pressed("zoom")):
			$Camera2D.zoom = Vector2(0.33, 0.33)
			zoom_active = true
			on_zoom_cooldown = true
			$zoom_cooldown.start(3)
	else:
		$zoom_key.visible = false
	
func _on_zoom_cooldown_timeout() -> void:
	if (zoom_active):
		#reset
		zoom_active = false
		$Camera2D.zoom = Vector2(1, 1)
		$zoom_cooldown.start(3)
	else:
		on_zoom_cooldown = false

func _on_islandfruit_1_islandfruit_collected() -> void:
	Global.island5_fruit1_collected = true

func _on_islandfruit_2_islandfruit_collected() -> void:
	Global.island5_fruit2_collected = true


func _on_islandfruit_3_islandfruit_collected() -> void:
	Global.island5_fruit3_collected = true

func _on_islandfruit_4_islandfruit_collected() -> void:
	Global.island5_fruit4_collected = true

func _on_islandfruit_5_islandfruit_collected() -> void:
	Global.island5_fruit5_collected = true

func _on_npc_island_trader_unique_trade_completed() -> void:
	Global.island5_npc_traded = true
