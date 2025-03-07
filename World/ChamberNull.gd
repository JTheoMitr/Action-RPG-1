extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var body = $AnimatedSprite
# Called when the node enters the scene tree for the first time.
func _ready():
	body.frame = random_drop_generator([0, 1, 2, 3])
	body.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()
