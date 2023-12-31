extends StaticBody2D

onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	timer.start()




func _on_Timer_timeout():
	self.show()
