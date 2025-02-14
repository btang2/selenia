extends Node

#not sure if needed atm, maybe for player stats would be useful, or if we wanted single player

var from_id = "" #default, change if not from somewhere, use when instantiating maps

#both should be initialized upon spawn
var player_inv = ["", "", "", "", "", "", "", ""] #global record of player inventory
var player_inv_count = [0, 0, 0, 0, 0, 0, 0, 0] #global record of player inventory count (how much each item)
