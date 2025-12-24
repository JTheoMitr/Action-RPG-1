extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	self.show()
	timer.start()


func _on_Timer_timeout():
	self.hide()
