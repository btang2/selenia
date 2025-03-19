extends Node2D

var t = 0.0
var portal_t = 0.0
var spaceship_active = false
var return_key_highlighted = false

func _ready() -> void:
	#Global.quest_number = 5 #just to get faster testing (MAKESURE 2 DISABLE)
	
	modulate = Color(0,0,0)
	
	if (Global.from_id != ""):
		$PlayerCat.position = get_node(str("./from_" + Global.from_id)).position
		portal_t = 0.0
		t = 0.0
	else:
		#start (w/ nicer fade)
		portal_t = 0.0
		$move_instruction.visible = true
		$quest_progress_bar.visible = true
		#$move_instruction_timer.start(5) #could be better instead to wait until player presses a key
		#Global.player_inv = ["res://resources/magicfruit.tres", "", "", "", "", "", "", ""]
		#Global.player_inv_count = [1, 0, 0, 0, 0, 0, 0, 0]
		#$inventory_gui.update()
	if (Global.quest_number <= 0):
		$"magicfruit-1".visible = true
		$"magicfruit-2".visible = true
		$"magicfruit-3".visible = true
	else:
		$"magicfruit-1".visible = false
		$"magicfruit-2".visible = false
		$"magicfruit-3".visible = false
	
	if (Global.portal_s1_active):
		$to_island_1.portal_active = true 
		$to_island_1._ready()
#this can surely to all scenes non-manually, surely, but will do manual for now

func _process(delta: float) -> void:
	if (portal_t <= 2):
		modulate = Color(portal_t/2, portal_t/2, portal_t/2)
		portal_t += delta
	if ($move_instruction.visible):
		t += 3*delta
		$move_instruction/W.scale = Vector2(0.01*sin(t) + 0.3, 0.01*sin(t) + 0.3)
		$move_instruction/A.scale = Vector2(0.01*sin(t+0.5) + 0.3, 0.01*sin(t+0.5) + 0.3)
		$move_instruction/S.scale = Vector2(0.01*sin(t+1) + 0.3, 0.01*sin(t+1) + 0.3)
		$move_instruction/D.scale = Vector2(0.01*sin(t+1.5) + 0.3, 0.01*sin(t+1.5) + 0.3)
	
	if (Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down") || Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right")):
		$move_instruction.visible = false
	if (Global.quest_number == 5):
		$SpaceshipCamera/PointLight2D.visible = true
	if (spaceship_active):
		t += delta
		if (t < 10):
			$SpaceshipCamera.zoom -= Vector2(0.05 * delta, 0.05*delta)
			$Spaceship.scale += Vector2(0.12 * delta, 0.12*delta)
			$Spaceship.position.y -= 100*delta #up, up and away (test)
			$base_ground.modulate = Color(1-0.95*t/10,1-0.95*t/10,1-0.95*t/10, 0.9)
			$Spaceship/PointLight2D.energy -= 1.5 * 0.03 * delta
		elif (t > 10 && t < 14):
			#$Spaceship.position.y -= 100*delta #up, up and away (test)
			#$SpaceshipCamera.offset.y += 100*delta
			#$SpaceshipCamera/Titletext.offset.y += 120*delta
			#$SpaceshipCamera/Titletext2.offset.y += 120*delta
			#$SpaceshipCamera/Titlelight.offset.y += 15*delta
			$SpaceshipCamera/Titletext.scale = Vector2(0.25 + 0.002*sin(t), 0.25 + 0.002*sin(t))
			$SpaceshipCamera/Titletext2.scale = Vector2(0.25 + 0.002*sin(t), 0.25 + 0.002*sin(t))
			$SpaceshipCamera/Titlelight.energy = 1.2*(t-10)/4
			
			$SpaceshipCamera/Titletext.visible = true
			$SpaceshipCamera/Titletext2.visible = true
			$SpaceshipCamera/Titlelight.visible = true
			$SpaceshipCamera/return.visible = true
			
		else:
			
			$SpaceshipCamera/Titletext.scale = Vector2(0.25 + 0.002*sin(t), 0.25 + 0.002*sin(t))
			$SpaceshipCamera/Titletext2.scale = Vector2(0.25 + 0.002*sin(t), 0.25 + 0.002*sin(t))
			$SpaceshipCamera/return.scale = Vector2(1 + 0.05*cos(t), 1+0.05*sin(t))
			#$SpaceshipCamera/return.global_position = $SpaceshipCamera/Titletext.global_position + Vector2(0, 120)
			
			if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && return_key_highlighted):
				var start_scene = "res://scenes/title_screen.tscn"
				get_tree().change_scene_to_file(start_scene)
			

func _on_spaceship_entered_spaceship() -> void:
	$PlayerCat.visible = false
	$Camera2D.enabled = false
	$SpaceshipCamera.enabled = true
	spaceship_active = true
	t = 0
	
	$inventory_gui.visible = false
	$quest_progress_bar.visible = false
	


func _on_return_mouse_entered() -> void:
	return_key_highlighted = true
	$SpaceshipCamera/return.modulate = Color(0.95, 0.95, 0.95)

func _on_return_mouse_exited() -> void:
	return_key_highlighted = false
	$SpaceshipCamera/return.modulate = Color(0.8, 0.8, 0.8)
