extends Area2D

const Slime = preload("res://Enemies/SlimeLaserLeftStraight.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var slime = Slime.instance()
	get_parent().add_child(slime)
	slime.global_position = global_position
