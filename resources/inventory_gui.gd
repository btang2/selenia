extends CanvasLayer

#maybe this is more like a hotbar than inventory


func _ready():
	for i in range(Global.player_inv.size()):
		var slot = InventorySlot.new(ItemData.Type.EMPTY, Vector2(24, 24))
		%Inv.add_child(slot)
	update()
func _process(delta: float) -> void:
	update() #dynamically check for updates & rebuild the inventory every time
	#pass
	#if (Input.is_action_just_pressed("i")):
	#	self.visible = !self.visible #disable later to be always on

func update():
	for j in range(Global.player_inv.size()):
		if (Global.player_inv[j] != "" && Global.player_inv_count[j] != 0): 
			var children = %Inv.get_child(j).get_children()
			for child in children:
				child.free()
			#free children
			var item = InventoryItem.new(load(Global.player_inv[j]))
			var count = InventoryCount.new(Global.player_inv_count[j])
			%Inv.get_child(j).add_child(item)
			%Inv.get_child(j).add_child(count)
