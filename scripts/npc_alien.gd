extends CharacterBody2D

enum COW_STATE {IDLE, WALK}

@export var move_speed : float = 20
@export var walk_time: float = 5
@export var idle_time: float = 2

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var c_key = $c_key

var current_dialogue_id = -1

#don't need to do anything? this is going to be the alien


var is_chatting = false
var player
var player_in_chat_zone = false

func _ready():
	player_in_chat_zone = false
	#sprite.flip_h = true
	#select_new_direction()
	#pick_new_state()
	
func _process(_delta) -> void:
	#movement/switching state mechanic goes here
	if (player_in_chat_zone && Input.is_action_just_pressed("chat")): #currently "c"
		if (!is_chatting):
			print("chatting w/ alien")
			c_key.visible = false
			$Chatbox.start(current_dialogue_id)
			current_dialogue_id = $Chatbox.current_dialogue_id 
			is_chatting = true
		else:
			print("stopped chatting w/ alien")
			#current_dialogue_id = $Chatbox.current_dialogue_id - 1
			c_key.visible = true
			$Chatbox.cancel_dialogue()
			current_dialogue_id = $Chatbox.current_dialogue_id 
			is_chatting = false
	#elif (!player_in_chat_zone):
	#	current_dialogue_id = $Chatbox.current_dialogue_id - 1
	#	$Chatbox.cancel_dialogue()
	#	is_chatting = false
	#if (current_dialogue_id < -1):
	#	current_dialogue_id = -1
	
func _on_chat_detection_body_entered(body: Node2D) -> void:
	#print(body.name)
	if (body.name.match("PlayerCat")):
		player = body
		player_in_chat_zone = true
		c_key.visible = true
		#print("player entered chat zone")


func _on_chat_detection_body_exited(body: Node2D) -> void:
	if (body.name.match("PlayerCat")):
		player = body
		player_in_chat_zone = false
		c_key.visible = false
		if (is_chatting):
			is_chatting = false
			$Chatbox.cancel_dialogue()
			current_dialogue_id = $Chatbox.current_dialogue_id 
		#print("player exited chat zone")


func _on_timer_timeout() -> void:
	timer.wait_time = 1 #could be random, set later, state doesnt matter since idle atm
	
func _on_chatbox_dialogue_finished() -> void:
	current_dialogue_id = $Chatbox.current_dialogue_id 
	is_chatting = false
	

"""
func _physics_process(_delta):
	
	#if (current_state == COW_STATE.WALK):
	#	velocity = move_direction * move_speed
	#	move_and_slide()
	
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	if (move_direction.x < 0):
		sprite.flip_h = true
	elif (move_direction.x > 0):
		sprite.flip_h = false
		

func pick_new_state():
	if (current_state == COW_STATE.IDLE):
		state_machine.travel("Walk")
		current_state = COW_STATE.WALK
		select_new_direction()
		timer.start(walk_time)
	elif (current_state == COW_STATE.WALK):
		state_machine.travel("Idle")
		current_state = COW_STATE.IDLE
		timer.start(idle_time)

"""
