extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var panel = $Panel
onready var musicLabel = $MusicLabel
onready var qrCode = $QRCode
onready var music = $AudioStreamPlayer
var musicSelection
# Called when the node enters the scene tree for the first time.
func _ready():
	panel.hide()
	musicSelection = 0
	music.play()
	musicLabel.bbcode_text = "[center]Rozanzu - Harper's Sill"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_focus_entered():
	panel.show()
	qrCode.show()


func _on_Button_focus_exited():
	panel.hide()
	qrCode.hide()
