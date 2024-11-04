extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var panel = $Panel
onready var musicLabel = $MusicLabel
onready var qrCode = $QRCode
onready var music = $AudioStreamPlayer
onready var harperTune = preload("res://Music and Sounds/HarperOnTheSill1.6.wav")
onready var vibeTune = preload("res://Music and Sounds/KOTWB_VIBE.wav")
var musicSelection
# Called when the node enters the scene tree for the first time.
func _ready():
	panel.hide()
	musicSelection = 0
	music.play()
	musicLabel.bbcode_text = "[center]Rozanzu - Harper's Sill"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if musicSelection == 0:
		musicLabel.bbcode_text = "[center]Rozanzu - Harper's Sill"

	elif musicSelection == 1:
		musicLabel.bbcode_text = "[center]Moleman - Vanilla Vibrato"



func _on_Button_focus_entered():
	panel.show()
	qrCode.show()


func _on_Button_focus_exited():
	panel.hide()
	qrCode.hide()


func _on_Button_pressed():
	if musicSelection == 0:
		musicSelection = 1
		music.stream = vibeTune
		music.play()
	else:
		musicSelection = 0
		music.stream = harperTune
		music.play()
