extends Node2D


var item_name


var item_quantity
var stack_size
#onready var MainxData = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("MainData")




func _ready():
	
	randomize()
	
	var rander = randi() %3
	
	if rander == 0:
		item_name = 0
	
	elif rander == 1:
		item_name = 2
		
	else:
		item_name = 5
	
	$TextureRect.texture = load("res://Inventory/item_icons/" + str(item_name) + ".png")

#	stack_size = MainxData.stacker(str(item_name))   #main change to use sqlite data base
#	item_quantity = randi() % stack_size + 1

	
#	if stack_size == 1:
#		$Label.visible = false
#
#	else:
#		$Label.visible = true
#		$Label.text = String((item_quantity))

	


func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String((item_quantity))  



func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)


#NEW STUFF

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://Inventory/item_icons/" + str(item_name) + ".png")
	var stack_size = (MainData.stacker(item_name))
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)
