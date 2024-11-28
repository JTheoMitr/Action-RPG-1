extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var chimeOne = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	#SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")
	chimeOne.play()
	#SceneTransitionLong.change_scene("res://World2.tscn")
	#SceneTransitionLong.change_scene("res://IntroStory.tscn")
	#SceneTransitionLong.change_scene("res://World.tscn")
	SceneTransitionLong.change_scene("res://UI/WorldMapScreen.tscn")
