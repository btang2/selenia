extends Area2D

var player_in_zone = false
var collected = false

func _ready():
	player_in_zone = false
	$f.visible = false
	

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("collect") && player_in_zone):
		collected = true
		Global.add_inv("res://resources/magicfruit.tres", 1)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_zone = true
		$f.visible = true

func _on_body_exited(body: Node2D) -> void:
	if (body.name == "PlayerCat"):
		player_in_zone = false
		$f.visible = false	
