extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pushTimer = $PushTimer
onready var stopTimer = $StopTimer
onready var frog = $AnimatedSprite
var pushin
var newDirection
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pushin:
		if newDirection == "Right":
			frog.global_position.x += 0.3
		elif newDirection == "Left":
			frog.global_position.x -= 0.3
	


func _on_AnimatedSprite_animation_finished():
	pushTimer.start()
	newDirection = random_drop_generator(["Left", "Right"])
	if newDirection == "Right":
		frog.flip_h = false
	elif newDirection == "Left":
		frog.flip_h = true


func _on_PushTimer_timeout():
	pushin = true
	stopTimer.start()


func _on_StopTimer_timeout():
	pushin = false
