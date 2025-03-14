extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var greenScreen = $Sprite2
var hidden
# Called when the node enters the scene tree for the first time.
func _ready():
	hidden = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hidden:
		greenScreen.hide()
	else:
		greenScreen.show()


func _on_Timer_timeout():
	if hidden:
		hidden = false
	else:
		hidden = true
