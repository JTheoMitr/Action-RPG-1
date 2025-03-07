extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var repositionTimer = $Reposition
var up
var down
# Called when the node enters the scene tree for the first time.
func _ready():
	up = false
	down = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x += 0.8
	self.rotation_degrees += 1.3
	
	if up:
		global_position.y -= .25
	if down:
		global_position.y += .25


func _on_Timer_timeout():
	if up:
		up = false
		down = true
	else:
		up = true
		down = false


func _on_Reposition_timeout():
	global_position.y -= 3000
