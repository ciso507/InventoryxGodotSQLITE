extends Node2D



const SlotClass = preload("res://Inventory/Slot.gd")
onready var hotbar_slots = $HotbarSlots
onready var slots = hotbar_slots.get_children()

var stringer
#var a = MainData.itemDataDB()

var itemname
var item_name
onready var active_item_label = $ActiveItemLabel



# Called when the node enters the scene tree for the first time.

func _ready():

	PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
	for i in range(slots.size()):    #i means replaceing each one of the slots.
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slot_index = i  #slot index is initialize here.
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		
	initialize_hotbar()
	update_active_item_label()



func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		var pre_go = slots[PlayerInventory.active_item_slot].item.item_name[0]
		active_item_label.text = MainData.item_name(pre_go)
	else:
		active_item_label.text = ""



func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])



func _input(event):
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()




func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UserInterface").holding_item != null:
				if !slot.item: #place holding item to slot (Empty slot)
					left_click_empty_slot(slot)
				else: #Swap holding item with item in slot  (into a Different item)
					if find_parent("UserInterface").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else: # (Same item)
						left_click_same_item(slot)
						
						
			elif slot.item: #(No holding item)
				left_click_not_holding(slot)
			update_active_item_label()
			
#	pass # Replace with function body.



func left_click_empty_slot(slot):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)  #holding item = the item you are grabing form slot
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null




func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)   #slot is the item that is inside  before you grab the item
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item



func left_click_same_item(slot: SlotClass):
	var stack_size = (MainData.stacker(slot.item.item_name))
	var able_to_add = (stack_size) - slot.item.item_quantity
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

