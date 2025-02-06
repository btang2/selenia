extends Area2D

var player
var player_in_portal = false
var portal_active = true #should start as false, but mechanic not implemneted

@export var to = "spawn_island" #set this BEFORE making scene
@export var from = "spawn" #target spawn point (marker2d), set BEFORE making scene

@onready var timer = $Timer
#TODO: add resource requirement to open portal, also TODO, make it custom for each portal

#func _ready(scene_path) -> void:
#	new_scene_path = scene_path Bugged

func _ready():
	#still need to pass target PlayerCat through 
	
	timer.wait_time = 3 #prevent portal loop

func _on_body_entered(body: Node2D) -> void:
	if (body.name.match("PlayerCat") && portal_active):
		player = body
		player_in_portal = true
		timer.start(2) #arbitrary atm, ideally start a global "fade out" type transition
		#var current_scene_file = get_tree().current_scene.scene_file_path #for debug


func _on_body_exited(body: Node2D) -> void:
	if (body.name.match("PlayerCat")):
		player = body
		player_in_portal = false
		timer.stop()


func _on_timer_timeout() -> void:
	var new_scn = ("res://scenes/" + to + ".tscn")
	Global.from_id = from #for each scene shoudld load different pos depending on where from
	#var instance = new_scn.instantiate()
	#add_child(instance)
	get_tree().change_scene_to_file(new_scn)
	#lastly, set position to last player position of prev scene, shifted down? not sure how to do
		
