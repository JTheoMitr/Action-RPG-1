extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var button1 = $AnimatedSprite3/Backlit/PanelContainer/ScrollContainer/VBoxContainer/Button
onready var nightSky1 = $Bgnd1
onready var nightSky2 = $Bgnd2

var night_sky_1_up
var night_sky_2_up

# Called when the node enters the scene tree for the first time.
func _ready():
	button1.grab_focus()
	night_sky_1_up = false
	night_sky_2_up = true

func _process(delta):

	if night_sky_1_up and nightSky1.self_modulate.a <= 1.00:
		nightSky1.self_modulate.a += .005
	if night_sky_2_up and nightSky1.self_modulate.a >= 0.0:
		nightSky1.self_modulate.a -= .005

func _on_SkyTimer_timeout():
	print_debug("skytimer")
	if night_sky_1_up:
		night_sky_2_up = true
		night_sky_1_up = false
	else:
		night_sky_1_up = true
		night_sky_2_up = false


func _on_Button_button_down():
	$AnimatedSprite3/Backlit/PanelContainer/ScrollContainer/VBoxContainer/Button2.grab_focus()
