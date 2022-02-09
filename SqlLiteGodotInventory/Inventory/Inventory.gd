extends Node2D


#var stringer
#var a = MainData.itemDataDB()
const SlotClass = preload("res://Inventory/Slot.gd")
onready var inventory_slots = $InventorySlots
onready var slots = inventory_slots.get_children()

onready var equip_slots = $EquipSlots
onready var e_slots = equip_slots.get_children()

#onready var equip_slots = $EquipSlots.get_children()

onready var INVENTORYSLOTS = preload("res://Inventory/Slot.tscn")
onready var user_interface = find_parent("UserInterface")


#var ite = "Slime potion"
var itemname
var item_name
# Called when the node enters the scene tree for the first time.

#onready var MainxData = get_parent().get_parent().get_node("MainData")



func _ready():
	
#	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = SlotClass.SlotType.INVENTORY

	for i in range(e_slots.size()):
		e_slots[i].connect("gui_input", self, "slot_gui_input", [e_slots[i]])
		e_slots[i].slot_index = i
	e_slots[0].slotType = SlotClass.SlotType.SHIRT
	e_slots[1].slotType = SlotClass.SlotType.PANTS
	e_slots[2].slotType = SlotClass.SlotType.SHOES

	initialize_inventory()
	initialize_equips()






func initialize_inventory():
#	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			(slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1]))  #str fixed the multiple errors physcis process 
			


#new
 #str fixed the multiple errors physcis process 

func initialize_equips():
	for i in range(e_slots.size()):
		if PlayerInventory.equips.has(i):
			e_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])
			


func slot_gui_input(_event: InputEvent, slot: SlotClass):
	if _event is InputEventMouseButton:
		if _event.button_index == BUTTON_LEFT && _event.pressed:
			if find_parent("UserInterface").holding_item != null:
				if !slot.item: #place holding item to slot (Empty slot)
					left_click_empty_slot(slot)
				else: #Swap holding item with item in slot  (into a Different item)
					if find_parent("UserInterface").holding_item.item_name != slot.item.item_name:
						left_click_different_item(_event, slot)
					else: # (Same item)
						left_click_same_item(slot)
						
						
			elif slot.item: #(No holding item)
				left_click_not_holding(slot)





func _input(_event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
		

func able_to_put_into_slot(slot: SlotClass):  #refers to the equipment container 
	var holding_item = find_parent("UserInterface").holding_item
	if holding_item == null:
		return true
#	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	var holding_item_category = MainData.item_category(holding_item.item_name)
	
	if slot.slotType == SlotClass.SlotType.SHIRT:
		return holding_item_category == "Shirt"

		
		
	elif slot.slotType == SlotClass.SlotType.PANTS:
		return holding_item_category == "Pants"
		
	elif slot.slotType == SlotClass.SlotType.SHOES:
		return holding_item_category == "Shoes"

	return true





func left_click_empty_slot(slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)  #holding item = the item you are grabing form slot
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null




func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)   #slot is the item that is inside  before you grab the item
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = temp_item



func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = (MainData.stacker(slot.item.item_name))
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity)
			slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)



func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()


