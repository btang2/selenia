extends CharacterBody2D

enum TRADER_STATE {IDLE, WALK}

@export var move_speed : float = 15
@export var walk_time: float = 5
@export var idle_time: float = 2


#basically same as npc_alien, but only has one functionality (trade x resource for y resource)
#some are repeatable, some aren't
#for simplicity, only 1 resource input and 1 resource output per npc

@export var input_resource = ""
@export var input_resource_quantity = 0
@export var output_resource = ""
@export var output_resource_quantity = 0
@export var trade_repeatable = true



@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var c_key = $c_key
@onready var equal_key = $equal_key


var is_chatting = false
var player
var player_in_chat_zone = false
var t = 0.0
var move_direction = Vector2(0,0)
var trade_possible = true
var traderstate = TRADER_STATE.IDLE #to be implemented very soon

func _ready():
	player_in_chat_zone = false
	$speech_bubble.visible = false
	$speech_bubble/input_text.text = str(input_resource_quantity) + "x" 
	$speech_bubble/input_sprite.texture = getSpriteTexture(input_resource)
	$speech_bubble/output_text.text = str(output_resource_quantity) + "x" 
	$speech_bubble/output_sprite.texture = getSpriteTexture(output_resource)
	#+ input_resource + "\n --> " + str(output_resource_quantity) + "x " + output_resource + "[/center]"
	#sprite.flip_h = true
	select_new_direction()
	pick_new_state()

func getSpriteTexture(resource):
	print("getting texture " + resource)
	if (resource == "metalore"):
		return preload("res://resources/metalore.tres").texture
	elif (resource == "metalscrap"):
		return preload("res://resources/metalscrap.tres").texture
	elif (resource == "emptyfueltank"):
		return preload("res://resources/emptyfueltank.tres").texture
	else:
		#harcode as needed
		return preload("res://resources/purpleportalkey.tres").texture


func _physics_process(_delta):
	
	if (traderstate == TRADER_STATE.WALK):
		velocity = move_direction * move_speed
		move_and_slide()
	
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	if (move_direction.x < 0):
		sprite.flip_h = false
	elif (move_direction.x > 0):
		sprite.flip_h = true
		

func pick_new_state():
	if (traderstate == TRADER_STATE.IDLE):
		state_machine.travel("Walk")
		traderstate = TRADER_STATE.WALK
		select_new_direction()
		timer.start(walk_time)
	elif (traderstate == TRADER_STATE.WALK):
		state_machine.travel("Idle")
		traderstate = TRADER_STATE.IDLE
		timer.start(idle_time)

func _process(_delta) -> void:
	t += 3*_delta
	$PointLight2D.energy = ((cos(Global.time) + 1.0) / 2.0) * 0.5
	#TODO movement/switching state mechanic goes here -- this actually useful for wandering npc
	
	if (player_in_chat_zone && trade_possible && traderstate == TRADER_STATE.IDLE): 
		var has_trade_items = Global.search_inv("res://resources/" + input_resource + ".tres") >=  input_resource_quantity
		#SHOULD NOT BE RELIANT ON CHATBOX -- use internal mechanism
		#$Chatbox.player_has_required = has_trade_items
		if (c_key.visible):
			c_key.scale = Vector2(0.01*sin(t) + 0.15, 0.01*sin(t) + 0.15)
		if (equal_key.visible):
			equal_key.scale = Vector2(0.02*sin(t) + 0.2, 0.02*sin(t) + 0.2)
			
		if (Input.is_action_just_pressed("chat")):
			if (!is_chatting):
				print("chatting w/ trader")
				c_key.visible = false
				equal_key.visible = has_trade_items
				$speech_bubble.visible = true
				is_chatting = true

			else:
				print("stopped chatting w/ trader")
				#current_dialogue_id = $Chatbox.current_dialogue_id - 1
				c_key.visible = true
				equal_key.visible = false
				$speech_bubble.visible = false
				is_chatting = false
				
		if (Input.is_action_just_pressed("fulfill_quest") && has_trade_items): #fulfill quest same as trade
			print("fulfilling trade: -" + str(input_resource_quantity) + " " + str(input_resource) + ", +" + str(output_resource_quantity) + " " + str(output_resource))
			Global.remove_inv("res://resources/" + input_resource + ".tres", input_resource_quantity)
			Global.add_inv("res://resources/" + output_resource + ".tres", output_resource_quantity)
			
			equal_key.visible = false
			
			#check repeatability
			if (!trade_repeatable):
				trade_possible = false
				$speech_bubble.visible = false
			else:
				equal_key.visible = Global.search_inv("res://resources/" + input_resource + ".tres") >= input_resource_quantity
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
		if (traderstate == TRADER_STATE.WALK):
			c_key.visible = false
		#print("player entered chat zone")


func _on_chat_detection_body_exited(body: Node2D) -> void:
	if (body.name.match("PlayerCat")):
		player = body
		player_in_chat_zone = false
		c_key.visible = false
		equal_key.visible = false
		if (is_chatting):
			is_chatting = false
			$speech_bubble.visible = false
		#print("player exited chat zone")

func _on_timer_timeout() -> void:
	timer.wait_time = 0.25 #could be random, set later, state doesnt matter since idle atm
	pick_new_state()
	if (traderstate == TRADER_STATE.WALK):
		c_key.visible = false
		equal_key.visible = false
		if (is_chatting):
			is_chatting = false
			$speech_bubble.visible = false
	if (traderstate == TRADER_STATE.IDLE):
		c_key.visible = true
		
