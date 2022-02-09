extends Node

#NEW STUFF

signal active_item_updated


const SlotClass = preload("res://Inventory/Slot.gd")
const ItemClass = preload("res://Inventory/Item.gd")


const NUM_HOTBAR_SLOTS = 6
const NUM_INVENTORY_SLOTS = 14

var active_item_slot = 0 #index of the active item
var slot
#onready var MainxData = get_tree().root.get_node("/root/Main/MainData")

var inventory = {
	0: [str(1), 2],     # 0: means inventory slot  "1" : means sword and so on... 1: means quantity
	1: [str(2), 1], 
	2: [str(0), 150], 
	3: [str(6), 25], 
	4: [str(1), 1],
	5: [str(5), 12],
}

var hotbar = {
#	0: [str(1), 2],     # 0: means inventory slot  "1" : means sword and so on... 1: means quantity
#	1: [str(2), 1], 
#	2: [str(0), 150],
#	3: [str(5), 150],
#	4: [str(4), 1],
#	5: [str(3), 1], #--->Slot_index: [item_name, item_quantity]  
}

var equips = {
	
}





# Called when the node enters the scene tree for the first time.
func _ready():
#	print(MainData, "legoo")
	pass # Replace with function body.






func add_item(item_name, item_quantity):
	for item in inventory:
#		if inventory.size() <= 5:
		if inventory[item][0] == (item_name):
			#TODO: Check if slot is full
			var stack_size = MainData.stacker(item_name)
			var able_to_add = stack_size - inventory[item][1]  #value able to add
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1]) #updates the visual with the item texture and the quantity index 0 and index 1
				return
			else: #we add what we can to the stack
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add


			
	#item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]  #this are indexes 0 is the texture; 1 is the quantity
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return




func update_slot_visual(slot_index, item_name, new_quantity):
	slot = get_tree().root.get_node("/root/Main/UserInterface/Inventory/InventorySlots/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, (new_quantity))
	else:
		slot.initialize_item(item_name, (new_quantity))





func remove_item(slot: SlotClass):   #it will delete the item from the inventory dict.
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)  #this way it will be completed deleted from the inventory dictionary
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:

			equips.erase(slot.slot_index)





func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]


func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		_:
			equips[slot.slot_index][1] += quantity_to_add



#new stufff sss

func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS # 5+1 = 6 % 6 == 0
	emit_signal("active_item_updated")


func active_item_scroll_down():
	if active_item_slot == 0:
		print("pizzaaaa")
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")



















