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
		text.bbcode_text = "[center]You've used a key[/center]"
	else:
		text.bbcode_text = "[center]You've obtained a key[/center]"


func _on_Timer_timeout():
	hide()
