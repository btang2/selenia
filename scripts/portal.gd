extends Area2D

var player
var player_in_portal = false

@export var to = "spawn_island" #set this BEFORE making scene
@export var from = "spawn" #target spawn point (marker2d), set BEFORE making scene

@export var portal_active = false #should start as false, but mechanic not implemneted
@export var color = "blue" #what color gem necessary to open

@onready var timer = $Timer
#TODO: add resource requirement to open portal, also TODO, make it custom for each portal

#func _ready(scene_path) -> void:
#	new_scene_path = scene_path Bugged
var t = 0.0

func _ready():
	#still need to pass target PlayerCat through 
	if (portal_active):
		$AnimationPlayer.play(color)
		$PointLight2D.visible = true
	else:
		$AnimationPlayer.play("idle")
		$PointLight2D.visible = false
	timer.wait_time = 1.5 #prevent portal loop
	
func _process(delta: float) -> void:
	t += 3*delta
	$PointLight2D.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.5
	if ($f_key.visible):
		$f_key.scale = Vector2(0.02*sin(t) + 0.25, 0.02*sin(t) + 0.25)
	if (Input.is_action_just_pressed("collect") && player_in_portal && !portal_active):
		if (Global.search_inv("res://resources/" + color + "portalkey.tres", 1)):
			#activate portal
			print("portal from " + from + " to " + to + " opened")
			$f_key.visible = false
			portal_active = true
			Global.remove_inv("res://resources/" + color + "portalkey.tres", 1)
			$PointLight2D.visible = true
			$AnimationPlayer.play(color)
			
			if (player_in_portal):
				timer.start(2)
			

func _on_body_entered(body: Node2D) -> void:
	if (body.name.match("PlayerCat")):
		player = body
		player_in_portal = true
		if (portal_active):
			timer.start(2) #arbitrary atm, ideally start a global "fade out" type transition
		else:
			#check if player has resource
			if (Global.search_inv("res://resources/" + color + "portalkey.tres", 1)):
				$f_key.visible = true
		#var current_scene_file = get_tree().current_scene.scene_file_path #for debug


func _on_body_exited(body: Node2D) -> void:
	if (body.name.match("PlayerCat")):
		player = body
		player_in_portal = false
		timer.stop()
		$f_key.visible = false


func _on_timer_timeout() -> void:
	var new_scn = ("res://scenes/" + to + ".tscn")
	Global.from_id = from #for each scene shoudld load different pos depending on where from
	#var instance = new_scn.instantiate()
	#add_child(instance)
	get_tree().change_scene_to_file(new_scn)
	#lastly, set position to last player position of prev scene, shifted down? not sure how to do
		
