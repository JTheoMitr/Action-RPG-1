extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	$Timer2.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")





func _on_Timer2_timeout():
	$VomvisTTS.play()
