extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var popup = $PopupDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	pass # Replace with function body to pop up the rune collected message and add to player stats and pause the player
	
