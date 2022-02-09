extends KinematicBody2D




var item_name


func _ready():
	item_name = str(5)




func _on_Area2D_body_entered(_body):
	
	if PlayerInventory.inventory.size() < 14:
		PlayerInventory.add_item(item_name, 1)
		queue_free()
	else:
		print("dont go anywhere")

