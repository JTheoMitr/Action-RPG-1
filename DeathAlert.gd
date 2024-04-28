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

func _ready():
	PlayerStats.connect("no_health", self, "show_death_alert")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _reset_stats():
	stats.health = 4
	stats.overcharge = false
	stats.batteries = 2
	stats.coins = 0
	# stats.keys = 0
	stats.boss_keys = 0
	stats.xp = 0
	stats.level = 1
	worldStats.freed = 0
	


func _on_Timer_timeout():
	#need to make a reset_stats method:
	_reset_stats()
	SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")


func _on_Button_pressed():
	#need to make a reset_stats method:
	_reset_stats()
	
	SceneTransitionLong.change_scene("res://World.tscn")
