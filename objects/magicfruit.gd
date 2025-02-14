extends Area2D

var player_in_zone = false
var collected = false

func _ready():
	player_in_zone = false
	$f.visible = false
	

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("collect") && player_in_zone):
		collected = true
		handle_collect()


func _on_body_entered(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_zone = true
		$f.visible = true

func _on_body_exited(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_zone = false
		$f.visible = false	
		
func handle_collect():
	#check for existing collection
	var player_has_resource = false
	var first_available_slot = -1
	for i in range(Global.player_inv.size()):
		if (Global.player_inv[i] == ""):
			if (first_available_slot == -1):
				first_available_slot = i
		elif (load(Global.player_inv[i]).name == "magicfruit"):
			player_has_resource = true
			Global.player_inv_count[i] += 1
			break
	if (!player_has_resource):
		#find first available slot and use that 
		if (first_available_slot == -1):
			assert(false, "ERROR: INVENTORY FULL");
		else:
			Global.player_inv[first_available_slot] = "res://resources/magicfruit.tres"
			Global.player_inv_count[first_available_slot] = 1
	queue_free()
			
