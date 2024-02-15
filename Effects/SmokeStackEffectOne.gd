extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.frame = random_drop_generator([0, 1, 2])

func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
