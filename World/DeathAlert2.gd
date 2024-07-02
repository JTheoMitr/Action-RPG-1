extends PopupDialog

const DeathSound = preload("res://Music and Sounds/DeathMelody.tscn")

var stats = PlayerStats
var worldStats = WorldStats


func show_death_alert():
	popup()
	var deathSound = DeathSound.instance()
	get_tree().current_scene.add_child(deathSound)
	$Timer.start(9)
	$Button.grab_focus()
	worldStats.emit_signal("fade_music_out")

func _ready():
	stats.connect("no_health", self, "show_death_alert")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _reset_stats():
	stats.reset()


func _on_Timer_timeout():
	#need to make a reset_stats method:
	_reset_stats()
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")


func _on_Button_pressed():
	#need to make a reset_stats method:
	_reset_stats()
	SceneTransitionLong.change_scene("res://World2.tscn")
