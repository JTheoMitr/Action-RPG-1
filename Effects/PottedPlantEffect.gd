extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")
	
	var sound = random_drop_generator(["sound1", "sound2", "sound3"])
	if (sound == "sound1"):
		$Sound1.play(0.0)
	elif (sound == "sound2"):
		$Sound2.play(0.0)
	elif (sound == "sound3"):
		$Sound3.play(0.0)
	
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()




func _on_animation_finished():
	queue_free()
