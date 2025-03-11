extends Node

#not sure if needed atm, maybe for player stats would be useful, or if we wanted single player

var from_id = "" #default, change if not from somewhere, use when instantiating maps

#both should be initialized upon spawn
var player_inv = ["", "", "", "", "", "", "", ""] #global record of player inventory
var player_inv_count = [0, 0, 0, 0, 0, 0, 0, 0] #global record of player inventory count (how much each item)
var quest_number = -1 #before discovering alien
var quest_part = 1 #for quests with multiple parts
var stored_quest_num = -1 #to track changes in quest

#portal transitions; only have to do half (s1, 1s governed by same variable)
var portal_s1_active = false
var portal_12_active = false

var portal_23_active = false
var portal_24_active = false
var portal_45_active = false

var portal_26_active = false
var portal_67_active = false

var time = 0 #start out midnight

var ore_mined = 0 #global variable for mining minigame
var mining_cooldown = 0.25 #for mining (default 0.25), ideally exchange ore for pickaxe to reduce this
var ore_prob = 0.05 #probability a given stone block is actually ore (for generating map)
#expected = 24*13*ore_prob (=0.05) ~ expected ? ores per game

var developer_mode = false #true == on (easy mode)

func search_inv(id: String):
	#inv should be designed and maintained to have no duplicates
	var num_found = 0
	for i in range(Global.player_inv.size()):
		if (Global.player_inv[i] == id):
			num_found += Global.player_inv_count[i]
	return num_found
	
func remove_inv(id: String, count: int):
	#inv should be designed and maintained to have no duplicates
	#only call this function if there's for sure enough to remove
	var num_found = 0
	for i in range(Global.player_inv.size()):
		if (Global.player_inv[i] == id):
			Global.player_inv_count[i] -= count
			#player inv count = 0 is handles by inventory GUI (auto sets to [i] and clears children)
			#if (Global.player_inv_count[i] == 0): #if <0, something has gone very wrong
				#Global.player_inv[i] = "" #nothing left
				#weird partial error where the resource shows up but it's ont actually there... TODO fix
			return

func add_inv(id: String, count: int):
	var player_has_resource = false
	var first_available_slot = -1
	for i in range(Global.player_inv.size()):
		if (Global.player_inv[i] == ""):
			if (first_available_slot == -1):
				first_available_slot = i
		elif (Global.player_inv[i] == id):
			player_has_resource = true
			Global.player_inv_count[i] += count
			break
	if (!player_has_resource):
		#find first available slot and use that 
		if (first_available_slot == -1):
			assert(false, "ERROR: INVENTORY FULL");
		else:
			Global.player_inv[first_available_slot] = id
			Global.player_inv_count[first_available_slot] = count
