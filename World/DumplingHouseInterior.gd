extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var popup =$CanvasLayer/PopupDialog
onready var button1 = $CanvasLayer/PopupDialog/HBoxContainer/Button
# Called when the node enters the scene tree for the first time.
func _ready():
	popup.show()
	button1.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
