extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spinningLeft
var spinningRight
onready var centerRotateTimer = $CenterRotateTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	spinningLeft = false
	spinningRight = false
	#need to set up an on-area-entered to trigger the pin to fly up and rotate for about 2-3 seconds and then 
	#queue free - maybe two collisionshapes to determine if it shoots off to the right ot left?
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spinningLeft:
		self.rotation_degrees -= 3
	if spinningRight:
		self.rotation_degrees += 3




func _on_LeftSide_area_entered(area):
	spinningRight = true


func _on_RightSide_area_entered(area):
	spinningLeft = true


func _on_BowlingPin_area_entered(area):
	self.rotation_degrees = 180
	centerRotateTimer.start()


func _on_CenterRotateTimer_timeout():
	if self.rotation_degrees == 180:
		self.rotation_degrees = 0
	else:
		self.rotation_degrees = 180
		
