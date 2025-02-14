class_name ItemData
extends Resource
#bruce testing resources/inventory

enum Type {EMPTY, QUEST, PORTAL, FOOD, TRADE} 
#empty: empty
#quest: needed for quest
#portal: needed to unlock portal
#food: needed to maintain food
#trade: needed to trade with aliens
@export var type: Type
@export var name: String
@export var texture: Texture2D
