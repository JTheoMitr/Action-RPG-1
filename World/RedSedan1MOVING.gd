extends Node2D


onready var sprite = $Sprite

var goingLeft
var goingRight


# Called when the node enters the scene tree for the first time.
func _ready():
	goingLeft = false
	goingRight = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if global_position.x > 250:
		goingLeft = true
		goingRight = false
	if global_position.x < -500:
		goingLeft = false
		goingRight = true
	if goingRight:
		sprite.flip_h = true
		global_position.x += 1.8
	if goingLeft:
		sprite.flip_h = false
		global_position.x -= 1.8


