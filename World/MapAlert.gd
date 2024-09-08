extends PopupDialog

var stats = PlayerStats
onready var text = $RichTextLabel


func show_map_alert():
	popup()
	$Timer.start(3)

func _ready():
	stats.connect("map_pickup", self, "show_map_alert")
	


func _on_Timer_timeout():
	hide()
