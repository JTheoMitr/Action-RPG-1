extends Node2D

const NewSkill = preload("res://Music and Sounds/NewSkill.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var popup = $PopupDialog
onready var timer = $Timer
onready var rune = $Sprite
onready var magic = $AnimatedSprite
onready var healthUp = $PopupDialog2
onready var timer2 = $Timer2


var playerStats = PlayerStats


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position = self.global_position
	healthUp.rect_global_position = self.global_position


func _on_Area2D_area_entered(area):
	healthUp.popup()
	timer.start()
	magic.hide()
	rune.hide()
	playerStats.set_max_health(5)
	playerStats.set_health(5)
	var newSkill = NewSkill.instance()
	get_tree().current_scene.add_child(newSkill)
	
	


func _on_Timer_timeout():
	healthUp.hide()
	popup.popup()
	timer2.start()


func _on_Timer2_timeout():
	queue_free()
