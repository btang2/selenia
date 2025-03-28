extends CharacterBody2D

@export var move_speed : float = 150 #150, is 300 for debugging purposes
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var can_move = true

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var has_apple = false
var local_time = 0.0

func _ready():
	if (Global.developer_mode):
		move_speed = 300
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	local_time += _delta
	$PointLight2D.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.8 * (0.1*sin(local_time) + 0.9)
	#$Sprite2D.modulate = Vector4((cos(Global.time) + 1.0) / 2.0),1,1,1)
	#((cos(Global.time) + 1.0) / 2.0), (cos(Global.time) + 1.0) / 2.0), (cos(Global.time) + 1.0) / 2.0), 1)
	#input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if (!can_move):
		input_direction = Vector2(0,0) #can't move
	
	
	#update velocity
	if (abs(input_direction[0]) + abs(input_direction[1]) == 2):
		velocity = input_direction * move_speed * 0.717 
	else:
		velocity = input_direction * move_speed
	update_animation_parameters(input_direction)
	
	#move and slide function to move characteron map
	move_and_slide()
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		
func player():
	pass
