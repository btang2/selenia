extends CanvasLayer

var on_miner_cooldown = false
var t = 0.0

var cur_rot = 0.0
var stored_point = Vector2i(0,0)
var mining_active = false

#TODO: mining shaders (decrease visibility), random ore generation on ready
#technically you shouldn't be able to see ores through walls but oh well, super limited visibility (3x3 square) will prob do the trick
#for some reason light2d modifies island1 instead of thing, so might use custom fill

func _ready() -> void:
	#reset mining game
	#$MinerCat/PointLight2D.visible = true
	#do other reset actions
	cur_rot = $MinerCat/RayCast2D.global_rotation_degrees
	Global.ore_mined = 0
	
	#for debugging purposes
	#Global.mining_cooldown = 0.05

func _process(delta: float) -> void:
	cur_rot = $MinerCat/RayCast2D.global_rotation_degrees
	if ($MinerCat/RayCast2D.is_colliding()):
		#make sure colliding with stone/ore
		t += 3*delta
		$MinerCat/f_key.visible = true
		$MinerCat/f_key.scale = Vector2(0.02*sin(t) + 0.16, 0.02*sin(t) + 0.16)
		#print ($MinerCat/RayCast2D.get_collider())
		
		#figure out what it's colliding with
		var obj = $MinerCat/RayCast2D.get_collider()
		var point = obj.local_to_map($MinerCat/RayCast2D.get_collision_point())
		if (cur_rot == 90):
			point[0] -= 1
		if (cur_rot == -180 || cur_rot == 180):
			point[1] -= 1
		
		var block_type = obj.get_cell_tile_data(point)
		
		var atlas_coords = $MiningGame/PanelContainer/ores.get_cell_atlas_coords(stored_point)
		var source = $MiningGame/PanelContainer/ores.get_cell_source_id(stored_point)
		
		#highlight if is stone/ore
		if (obj == $MiningGame/PanelContainer/ores):
			
	
			#$MiningGame/PanelContainer/ores.set_cell(point, source_id, atlas_coords + Vector2i(1,  0))
			if (Input.is_action_just_released("collect") || point != stored_point): #stopped mining or hitbox changed
				$MiningGame/PanelContainer/ores.set_cell(stored_point, source, Vector2i(0, atlas_coords[1]))
				mining_active = false
				#reset current square (not intended functionality)
				#$MiningGame/PanelContainer/ores.set_cell(point, source_id, atlas_coord - Vector2i(1,  0))
			stored_point = point
			
			#if not highlighted, highlight current ore( @ current point )
			atlas_coords = $MiningGame/PanelContainer/ores.get_cell_atlas_coords(point)
			source = $MiningGame/PanelContainer/ores.get_cell_source_id(point)
			if (atlas_coords[0] == 0):
				$MiningGame/PanelContainer/ores.set_cell(point, source, Vector2i(1, atlas_coords[1]))
			
		
		
		if (Input.is_action_pressed("collect") && !on_miner_cooldown && obj == $MiningGame/PanelContainer/ores):
			atlas_coords = $MiningGame/PanelContainer/ores.get_cell_atlas_coords(point)
			source = $MiningGame/PanelContainer/ores.get_cell_source_id(point)
			mining_active = true
			#for left/up, thinks there's nothing there
			"""
			if (obj is TileMapLayer):
				print(obj)
				print(point)
				print(cur_rot)
				print($MiningGame/PanelContainer/ores.get_cell_atlas_coords(point))
			"""
			#(-1,-1) == nothing
			var new_atlas_coords = atlas_coords + Vector2i(1, 0)
			if (new_atlas_coords[0] > 4):
				#broken
				if (atlas_coords[1] == 1):
					Global.ore_mined += 1
				new_atlas_coords = Vector2i(-1,-1)
			$MiningGame/PanelContainer/ores.set_cell(point, source, new_atlas_coords)
			
			#enter cooldown
			$MinerCooldown.start(Global.mining_cooldown)
			on_miner_cooldown = true
	
		
		
	else:
		$MinerCat/f_key.visible = false
		if (mining_active):
			var atlas_coords = $MiningGame/PanelContainer/ores.get_cell_atlas_coords(stored_point)
			var source = $MiningGame/PanelContainer/ores.get_cell_source_id(stored_point)
			$MiningGame/PanelContainer/ores.set_cell(stored_point, source, Vector2i(0, atlas_coords[1]))
		#reset current square
		
	#if (Input.is_action_just_pressed("enter_mine")):
	#	get_tree().paused = false
	#	get_node("res://scenes/mining_minigame.tscn").queue_free()


func _on_miner_cooldown_timeout() -> void:
	on_miner_cooldown = false
