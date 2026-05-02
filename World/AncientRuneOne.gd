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

onready var heart1 = $PopupDialog2/Heart1
onready var heart2 = $PopupDialog2/Heart2
onready var heart3 = $PopupDialog2/Heart3
onready var heart4 = $PopupDialog2/Heart4
onready var heart5 = $PopupDialog2/Heart5
onready var heartTimer = $HeartTimer

onready var save_file = SaveFile.g_data
var playerStats = PlayerStats


# Called when the node enters the scene tree for the first time.
func _ready():
	heart5.hide()


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
	save_file.player_max_health = 5
	#save here?
	playerStats.controlsOn = false
	
	
	


func _on_Timer_timeout():
	healthUp.hide()
	popup.popup()
	timer2.start()


func _on_Timer2_timeout():
	playerStats.controlsOn = true #test this
	queue_free()


func _on_HeartTimer_timeout():
	if heart5.show():
		heart5.hide()
	else:
		heart5.show()
