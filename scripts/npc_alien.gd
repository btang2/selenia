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
@onready var equal_key = $equal_key

var current_dialogue_id = 0 #-1 originally

#don't need to do anything? this is going to be the alien


var is_chatting = false
var player
var player_in_chat_zone = false
var t = 0.0

func _ready():
	player_in_chat_zone = false
	#sprite.flip_h = true
	#select_new_direction()
	#pick_new_state()
	
func _process(_delta) -> void:
	t += 3*_delta
	#movement/switching state mechanic goes here
	if (player_in_chat_zone): 
		var has_quest_items = check_quest(Global.quest_number)
		$Chatbox.player_has_required = has_quest_items
		if (c_key.visible):
			c_key.scale = Vector2(0.02*sin(t) + 0.3, 0.02*sin(t) + 0.3)
		if (equal_key.visible):
			equal_key.scale = Vector2(0.02*sin(t) + 0.25, 0.02*sin(t) + 0.25)
			
		if (Input.is_action_just_pressed("chat")):
			if (!is_chatting):
				print("chatting w/ alien")
				c_key.visible = false
				equal_key.visible = has_quest_items
				$Chatbox.start()
				is_chatting = true
				print(current_dialogue_id) #check if 
			else:
				print("stopped chatting w/ alien")
				#current_dialogue_id = $Chatbox.current_dialogue_id - 1
				c_key.visible = true
				equal_key.visible = false
				$Chatbox.cancel_dialogue()
				is_chatting = false
	#elif (!player_in_chat_zone):
	#	current_dialogue_id = $Chatbox.current_dialogue_id - 1
	#	$Chatbox.cancel_dialogue()
	#	is_chatting = false
	#if (current_dialogue_id < -1):
	#	current_dialogue_id = -1

func check_quest(dialogue_id: int):
	#hard coded
	if (dialogue_id == 0):
		return Global.search_inv("res://resources/magicfruit.tres", 3)
		
	return false

func fulfill_quest(dialogue_id: int):
	#also hard coded, 1-to-1 w/ above, assume materials
	print("fulfilling quest: " + str(dialogue_id))
	if (dialogue_id == 0):
		Global.remove_inv("res://resources/magicfruit.tres", 3)
		Global.add_inv("res://resources/blueportalkey.tres", 1)
	
#search_inv, remove_inv, add_inv all global functions now

	
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
		equal_key.visible = false
		if (is_chatting):
			is_chatting = false
			$Chatbox.cancel_dialogue()
		#print("player exited chat zone")

func _on_chatbox_quest_completed() -> void:
	#do everything needed on completed quest (update materials sfx, etc)
	#update materials
	print("completed quest")
	fulfill_quest(Global.quest_number)
	
	#any sorta effects
	
	#make trade not repeatable
	equal_key.visible = false

func _on_timer_timeout() -> void:
	timer.wait_time = 0.25 #could be random, set later, state doesnt matter since idle atm
	
func _on_chatbox_dialogue_finished() -> void:
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
