extends PopupDialog

var stats = PlayerStats
onready var text = $RichTextLabel


func show_key_alert():
	popup()
	$Timer.start(3)

func _ready():
	stats.connect("keys_changed", self, "show_key_alert")



func _process(delta):
	if (stats.keyLost == true):
		text.text = "You've used a key"
	else:
		text.text = "You've obtained a key"


func _on_Timer_timeout():
	hide()
