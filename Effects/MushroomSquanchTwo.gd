extends AnimatedSprite

onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")




func _on_animation_finished():
	timer.start()
	

func _on_Timer_timeout():
	queue_free()
