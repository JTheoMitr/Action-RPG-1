extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mainButton = $HBoxContainer/Button
onready var music = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	mainButton.grab_focus()
	music.play(0.0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AudioStreamPlayer_finished():
	music.play(0.0)
