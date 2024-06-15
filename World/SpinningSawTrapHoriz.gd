extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var up = false
export var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	$Timer2.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()


func _on_Timer2_timeout():
	
	if up == false:
		global_position.x += 2
	else:
		global_position.x -= 2


func _on_Timer_timeout():
	if up == false:
		up = true
	else:
		up = false
		
