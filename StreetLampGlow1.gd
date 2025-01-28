extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var timer = $Timer
onready var timer2 = $Timer2
onready var sprite = $Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(0.0)
	timer2.start(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	sprite.show()


func _on_Timer2_timeout():
	sprite.hide()
