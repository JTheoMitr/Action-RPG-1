extends Node2D

const CashSound = preload("res://Music and Sounds/CashRegisterSound.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mainButton = $HBoxContainer/Button
onready var music = $AudioStreamPlayer
onready var popup = $PopupDialog
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	mainButton.grab_focus()
	music.play(0.0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AudioStreamPlayer_finished():
	music.play(0.0)


func _on_Button_pressed():
	var cashSound = CashSound.instance()
	get_tree().current_scene.add_child(cashSound)
	popup.popup()
	
	#set up health increase, folow suit for other buttons


func _on_PopupDialog_about_to_show():
	timer.start()


func _on_Timer_timeout():
	popup.hide()
