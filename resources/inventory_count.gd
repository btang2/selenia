class_name InventoryCount
extends Label

#display counts for inventory item

var count 
func _init(c: int) -> void:
	count = c
	
func _ready() -> void:
	text = str(count)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM 
	
	
	
#needs update mechanic? or will automaticlaly be deleted/recreated eventually
#worry about update in a higher-levelclass which has access to child index J
	
	
