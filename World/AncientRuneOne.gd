extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var popup = $PopupDialog
onready var timer = $Timer
onready var rune = $Sprite
onready var magic = $AnimatedSprite

var playerStats = PlayerStats


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	popup.popup()
	timer.start()
	magic.hide()
	rune.hide()
	playerStats.set_max_health(5)
	PlayerStats.health += 5
	
	


func _on_Timer_timeout():
	queue_free()
