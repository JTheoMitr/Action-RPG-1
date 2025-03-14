extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hidden
onready var redscrn1 = $Sprite2
onready var redscrn2 = $Sprite5
# Called when the node enters the scene tree for the first time.
func _ready():
	hidden = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hidden:
		redscrn1.hide()
		redscrn2.hide()
	else:
		redscrn1.show()
		redscrn2.show()


func _on_Timer_timeout():
	if hidden:
		hidden = false
	else:
		hidden = true
