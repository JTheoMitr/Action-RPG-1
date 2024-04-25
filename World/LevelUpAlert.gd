extends PopupDialog

const LevelUpSound = preload("res://Music and Sounds/LevelUp.tscn")

var stats = PlayerStats
var worldStats = WorldStats


func show_level_up_alert():
	if stats.level >= 2:
		popup()
		var lvlSound = LevelUpSound.instance()
		get_tree().current_scene.call_deferred("add_child", lvlSound)
		$RichTextLabel3.bbcode_text = "[center]You've reached Level %s[/center]" % stats.level
		$Button.grab_focus()
		get_tree().paused = true

func _ready():
	PlayerStats.connect("level_changed", self, "show_level_up_alert")


func _on_Button_pressed():
	get_tree().paused = false
	queue_free()
