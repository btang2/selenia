extends CharacterBody2D

@export var move_speed : float = 50 #half of normal speed in mine
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var can_move = true

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var has_apple = false

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	
	$PointLight2D.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.8
	#input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if (!can_move):
		input_direction = Vector2(0,0) #can't move
	
	
	#update velocity
	velocity = input_direction * move_speed
	update_animation_parameters(input_direction)
	
	#move and slide function to move characteron map
	move_and_slide()
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
		if (move_input[0] == -1):
			$RayCast2D.global_rotation_degrees = 90
		elif (move_input[0] == 1):
			$RayCast2D.global_rotation_degrees = -90
		elif (move_input[1] == -1):
			$RayCast2D.global_rotation_degrees = -180
		elif (move_input[1] == 1):
			$RayCast2D.global_rotation_degrees = 0

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		
