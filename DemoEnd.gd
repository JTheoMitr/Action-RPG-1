extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var button = $Button
onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	button.hide()
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	SaveFile.clear_save_file()
	button.show()
	button.grab_focus()


func _on_Button_pressed():
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")
