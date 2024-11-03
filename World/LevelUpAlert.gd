extends PopupDialog

const LevelUpSound = preload("res://Music and Sounds/LevelUp.tscn")

var stats = PlayerStats
var worldStats = WorldStats
onready var timer = $Timer

#func _process(delta):
#	if Input.is_action_just_pressed("interact"):
#		timer.start()


func show_level_up_alert():
	if stats.level >= 2 && stats.resetValue == false :
		print_debug(stats.level)
		popup()
		var lvlSound = LevelUpSound.instance()
		get_tree().current_scene.call_deferred("add_child", lvlSound)
		$RichTextLabel3.bbcode_text = "[center]You've reached Level %s[/center]" % stats.level
		$Button.grab_focus()
		SaveFile.save_data()
		#timer.start()
		get_tree().paused = true
		timer.start()

func _ready():
	PlayerStats.connect("level_changed", self, "show_level_up_alert")


func _on_Button_pressed():
	pass
	# print_debug("pressed")
	# timer.start(0.0)
	


func _on_Timer_timeout():
	
	print_debug("timed_out")
	get_tree().paused = false
	hide()
