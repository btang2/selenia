class_name InventoryItem
extends TextureRect

@export var data: ItemData

func _init(d: ItemData) -> void:
	data = d

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture = data.texture
	tooltip_text = "%s" % [data.name]
	
