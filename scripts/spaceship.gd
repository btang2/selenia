extends Node2D

signal entered_spaceship

var spaceship_ready = false
var spaceship_active = false
var player_in_region = false

func _ready():
	visible = false
	$CollisionShape2D.scale = Vector2(0.01, 0.01)
	$Base.visible = false
	$Engine.visible = false
	$Engineflames.visible = false
	$Shield.visible = false
	
	$equals_key.visible = false
	update_ship()

func _process(delta: float) -> void:
	$PointLight2D.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.5
	if (Global.quest_number != Global.spaceship_stage):
		update_ship()
	if (spaceship_ready):
		#do stuff
		if (Input.is_action_just_pressed("fulfill_quest") && player_in_region && !spaceship_active):
			#equals
			#edit animation
			$equals_key.visible = false
			spaceship_active = true
			$AnimationPlayer.play("spaceship_active")
			emit_signal("entered_spaceship")
	

func update_ship():
	print("updating ship")
	if (Global.quest_number == 1):
		$CollisionShape2D.scale = Vector2(1, 1)
		visible = true
		$Base.visible = true
		$Engine.visible = false
		$Engineflames.visible = false
		$Shield.visible = false
		
		$Base.frame = 3
		$Base.rotation_degrees = 120 #scrap
		$CollisionShape2D.rotation_degrees = 120
		
	elif (Global.quest_number == 2):
		#got metalscrap
		$CollisionShape2D.scale = Vector2(1, 1)
		visible = true
		$Base.visible = true
		$Engine.visible = false
		$Engineflames.visible = false
		$Shield.visible = false
		
		$Base.frame = 0
		$Base.rotation_degrees = 120 #scrap
		$CollisionShape2D.rotation_degrees = 120
		
	elif (Global.quest_number == 3):
		#got fueltank
		$CollisionShape2D.scale = Vector2(1, 1)
		visible = true
		$Base.visible = true
		$Engine.visible = true
		$Engineflames.visible = false
		$Shield.visible = false
		
		$Base.frame = 2
		$Base.rotation_degrees = 0
		$CollisionShape2D.rotation_degrees = 0
		
	elif (Global.quest_number == 4):
		#got enginescrap
		$CollisionShape2D.scale = Vector2(1, 1)
		visible = true
		$Base.visible = true
		$Engine.visible = true
		$Engineflames.visible = false
		$Shield.visible = false
		
		$Base.frame = 1
		$Base.rotation_degrees = 0
		$CollisionShape2D.rotation_degrees = 0
		
	elif (Global.quest_number == 5):
		#got solarpanel
		$CollisionShape2D.scale = Vector2(1, 1)
		visible = true
		$Base.visible = true
		$Engine.visible = true
		$Engineflames.visible = true
		$Shield.visible = true
		
		$Base.frame = 1
		$CollisionShape2D.rotation_degrees = 0
		$Base.rotation_degrees = 0
		spaceship_ready = true
		$AnimationPlayer.play("spaceship_ready")
		
	Global.spaceship_stage = Global.quest_number

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_region = true
		if (spaceship_ready):
			$equals_key.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_region = false
	$equals_key.visible = false
