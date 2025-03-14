extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var locked = $Locked
onready var leftSide = $LeftSide
onready var rightSide = $RightSide
onready var closingTimer = $Timer
onready var click = $Click
onready var openSound = $Open

var opening
var closing

# Called when the node enters the scene tree for the first time.
func _ready():
	closing = false
	opening = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if leftSide.position.x >= -97 && opening:
		leftSide.position.x -= 3
	if rightSide.position.x <= 97 && opening:
		rightSide.position.x += 3
		
	if leftSide.position.x <= -3 && closing:
		leftSide.position.x += 3
	if rightSide.position.x >= 3 && closing:
		rightSide.position.x -= 3


func _on_Area2D_area_entered(area):
	opening = true
	closing = false
	openSound.play()
	#closingTimer.stop()
	
	

func _on_Area2D_area_exited(area):
	opening = false
	closing = true
	if not is_inside_tree():
		return
	closingTimer.start()
	


func _on_Timer_timeout():
	if closing:
		locked.show()


func _on_Area2D2_area_entered(area):
	if opening == false:
		click.play()
		locked.hide()



