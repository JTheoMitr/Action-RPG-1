extends Node2D

const NewSkill = preload("res://Music and Sounds/NewSkill.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var popup = $PopupDialog
onready var timer = $Timer
onready var walkie = $Sprite
onready var magic = $AnimatedSprite
onready var walkieScooped = $PopupDialog2
onready var timer2 = $Timer2
onready var timer3 = $Timer3
onready var walkieMSG = $PopupDialog/RichTextLabel
onready var chatter = $Chatter

onready var save_file = SaveFile.g_data
var playerStats = PlayerStats


# Called when the node enters the scene tree for the first time.
func _ready():
	walkieMSG.text = " Excellent, you've \n found the 2-way \n radio That I left \n for you."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position = self.global_position
	walkieScooped.rect_global_position = self.global_position


func _on_Area2D_area_entered(area):
	walkieScooped.popup()
	timer.start()
	magic.hide()
	walkie.hide()
	playerStats.walkieObtained = true
	save_file.walkie_obtained = true
	SaveFile.save_data()
	#add this stat to the save file as well
	var newSkill = NewSkill.instance()
	get_tree().current_scene.add_child(newSkill)
	playerStats.controlsOn = false
	
	
	


func _on_Timer_timeout():
	chatter.play(0.0)
	walkieScooped.hide()
	popup.popup()
	timer2.start()
	timer3.start()
	


func _on_Timer2_timeout():
	playerStats.controlsOn = true #test this
	queue_free()



func _on_Timer3_timeout():
	chatter.play(0.0)
	walkieMSG.text = " Contact me \n when you arrive \n in the caverns..."
