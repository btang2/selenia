class_name InventorySlot
extends PanelContainer

@export var type: ItemData.Type

func _init(t: ItemData.Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms
	
