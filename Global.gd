extends Node

#not sure if needed atm, maybe for player stats would be useful, or if we wanted single player

var from_id = "" #default, change if not from somewhere, use when instantiating maps

#both should be initialized upon spawn
var player_inv = ["", "", "", "", "", "", "", ""] #global record of player inventory
var player_inv_count = [0, 0, 0, 0, 0, 0, 0, 0] #global record of player inventory count (how much each item)
var quest_number = 0
var time = PI #start out dawn

func search_inv(id: String, count: int):
	#inv should be designed and maintained to have no duplicates
	var num_found = 0
	for i in range(Global.player_inv.size()):
		if (Global.player_inv[i] == id):
			return Global.player_inv_count[i] >= count
	return false
	
func remove_inv(id: String, count: int):
	#inv should be designed and maintained to have no duplicates
	#only call this function if there's fs enough to remove
	var num_found = 0
	for i in range(Global.player_inv.size()):
		if (Global.player_inv[i] == id):
			Global.player_inv_count[i] -= count
			if (Global.player_inv_count[i] == 0): #if <0, something has gone very wrong
				Global.player_inv[i] = "" #nothing left
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
