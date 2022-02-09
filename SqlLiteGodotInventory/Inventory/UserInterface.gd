extends CanvasLayer


var holding_item = null
# Called when the node enters the scene tree for the first time.



func _input(event):
	if event.is_action_pressed("inventory"):
#		yield(get_tree().create_timer(1.0), "timeout")
		$Inventory.visible =! $Inventory.visible
		$Inventory.initialize_inventory()   #NEW Stuff
		
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()
