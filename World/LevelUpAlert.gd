extends PopupDialog

const LevelUpSound = preload("res://Music and Sounds/LevelUp.tscn")

onready var timer = $Timer

var stats = PlayerStats
var worldStats = WorldStats
var active

#func _process(delta):


func show_level_up_alert():
	if stats.level >= 2 && stats.resetValue == false :
		print_debug(stats.level)
		popup()
		var lvlSound = LevelUpSound.instance()
		get_tree().current_scene.call_deferred("add_child", lvlSound)
		$RichTextLabel3.bbcode_text = "[center]You've reached Level %s[/center]" % stats.level
		active = true
		SaveFile.save_data()
		timer.start()


func _ready():
	PlayerStats.connect("level_changed", self, "show_level_up_alert")
	active = false





func _on_Timer_timeout():
	hide()
	print_debug("hidden")
