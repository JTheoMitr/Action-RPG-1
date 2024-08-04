extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
onready var timer = $Timer

var zag = false

export var ACCELERATION = 300
export var MAX_SPEED = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position.x += 1
	
	if zag == false:
		self.global_position.y -= 1
	else:
		self.global_position.y += 1


func _on_Timer_timeout():
	queue_free()




func _on_ZagTimer_timeout():
	if zag == false:
		zag = true
	else:
		zag = false
		# can adjust zagtimer to adjust arc
			
