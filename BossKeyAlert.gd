extends PopupDialog

var stats = PlayerStats


func show_key_alert():
	popup()
	$Timer.start(3)

func _ready():
	stats.connect("boss_key_acquired", self, "show_key_alert")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	#stats.emit_signal("player_resumed")
	queue_free()
