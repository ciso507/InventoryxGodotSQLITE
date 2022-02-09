extends Panel


var default_tex = preload("res://Inventory/item_slot_default_background.png") 
var empty_tex = preload("res://Inventory/item_slot_empty_background.png")
var selected_tex = preload("res://Inventory/images/item_slot_selected_background.png")



#onready var tool_tip = preload("res://Inventory/NewToolTip.tscn")


var act_denied_toolTip = false

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://Inventory/Item.tscn")

const ItemGdClass = preload("res://Inventory/Item.gd")  #it has to be const to be a classs


var item_name

var slotType = null


enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	SHIRT,
	PANTS,
	SHOES,
}

var slot_index



var nm
var qt

var item = null



func _ready():


#	if randi() %2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
		
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()

	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex

	refresh_style()




func refresh_style():

	if slotType == SlotType.HOTBAR and PlayerInventory.active_item_slot == slot_index:
		set('custom_styles/panel', selected_style)
		
	elif item == null:

		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)



func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()


func pickFromSlot():
#	if act_denied_toolTip:
#		get_node("Canvas/NewToolTip").free()
#		act_denied_toolTip = false
#
	remove_child(item)
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.add_child(item)
	item = null
	refresh_style()



#NEW stuff

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, (item_quantity))
	
	else:
		item.set_item(item_name, (item_quantity))
	refresh_style()
	



