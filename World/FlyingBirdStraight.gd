extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
onready var timer = $Timer

export var ACCELERATION = 300
export var MAX_SPEED = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.time_left <= 30.0:
		self.flip_h = false
		self.global_position.x -= 1
		

	elif timer.time_left >= 30.1:
		self.flip_h = true
		self.global_position.x += 1
	


func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	self.flip_h = velocity.x < 0



