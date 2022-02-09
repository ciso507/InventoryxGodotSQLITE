extends KinematicBody2D


var velocity = Vector2()
var speed = 345

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(_delta):
	move_state(_delta)



func move_state(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		
		velocity = (input_vector * speed)

	else:
		velocity = Vector2.ZERO
	move()



func move():
	velocity = move_and_slide(velocity)


func add_item():
	print("copy")

