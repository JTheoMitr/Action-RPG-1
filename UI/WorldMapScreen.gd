extends ColorRect

onready var wolfIcon = $WhiteWolf
onready var forestButton = $ForestButton
onready var caveButton = $CaveButton
onready var marshButton = $MarshButton
onready var cityButton = $CityButton
onready var desertButton = $DesertButton
onready var blizzardButton = $BlizzardButton
onready var levelText = $RichTextLabel
onready var levelPreText = $RichTextLabel2
onready var selectSound = $SelectSound
onready var pressSound = $PressSound
onready var mapMusic = $MapMusic
onready var timer = $Timer
onready var tween_out = $Tween
onready var playerLevelText = $LevelText
onready var coinText = $CoinText
onready var xpText = $XpText
onready var ammoText = $AmmoText
onready var levelLabel = $LevelLabel
export var transition_duration = 2.00
export var transition_type = 1 # TRANS_SINE

onready var stats = PlayerStats
onready var save_file = SaveFile.g_data


func fade_out(stream_player):
	# tween music volume down to 0
	tween_out.interpolate_property(stream_player, "volume_db", -5, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	# when the tween ends, the music will be stopped


# Called when the node enters the scene tree for the first time.
func _ready():
	forestButton.grab_focus()
	mapMusic.play(0.0)
	selectSound.volume_db = -60
	timer.start(0.0)
	SaveFile.load_data()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	playerLevelText.text = "Level " + str(save_file.player_level)
	coinText.text = "x " + str(save_file.player_coins)
	xpText.text = "x " + str(save_file.player_xp)
	ammoText.text = "x " + str(save_file.player_ammo)
	
	if forestButton.has_focus():
		wolfIcon.position.x = 191
		wolfIcon.position.y = 159
		levelPreText.text = "The"
		levelText.text = "Forest"
		levelLabel.bbcode_text = "[center]The Forest"
	if caveButton.has_focus():
		wolfIcon.position.x = 171
		wolfIcon.position.y = 142
		levelPreText.text = "Wylde"
		levelText.text = "Caverns"
		levelLabel.bbcode_text = "[center]Wylde Caverns"
	if marshButton.has_focus():
		wolfIcon.position.x = 183
		wolfIcon.position.y = 112
		levelPreText.text = "Toad"
		levelText.text = "Marsh"
		levelLabel.bbcode_text = "[center]Toad Marsh"
	if cityButton.has_focus():
		wolfIcon.position.x = 174
		wolfIcon.position.y = 66
		levelPreText.text = "Arcade"
		levelText.text = "Heights"
		levelLabel.bbcode_text = "[center]Arcade Heights"
	if desertButton.has_focus():
		wolfIcon.position.x = 128
		wolfIcon.position.y = 85
		levelPreText.text = "The"
		levelText.text = "Desert"
		levelLabel.bbcode_text = "[center]The Desert"
	if blizzardButton.has_focus():
		wolfIcon.position.x = 152
		wolfIcon.position.y = 34
		levelPreText.text = "Blizzard"
		levelText.text = "Canyon"
		levelLabel.bbcode_text = "[center]Blizzard Canyon"
		
		



func _on_ForestButton_focus_entered():
	selectSound.play(0.0)


func _on_CaveButton_focus_entered():
	selectSound.play(0.0)


func _on_Timer_timeout():
	selectSound.volume_db = -7


func _on_MarshButton_focus_entered():
	selectSound.play(0.0)


func _on_CityButton_focus_entered():
	selectSound.play(0.0)


func _on_DesertButton_focus_entered():
	selectSound.play(0.0)


func _on_BlizzardButton_focus_entered():
	selectSound.play(0.0)


func _on_ForestButton_pressed():
	SceneTransitionLong.change_scene("res://World.tscn")
	pressSound.play(0.0)
	fade_out(mapMusic)


func _on_CaveButton_pressed():
	SceneTransitionLong.change_scene("res://World2.tscn")
	pressSound.play(0.0)
	fade_out(mapMusic)

# add a tween node and use introTitle fade out method


func _on_MarshButton_pressed():
	SceneTransitionLong.change_scene("res://World3.tscn")
	pressSound.play(0.0)
	fade_out(mapMusic)


func _on_CityButton_pressed():
	SceneTransitionLong.change_scene("res://World/DumplingHouseInterior.tscn")
	pressSound.play(0.0)
	fade_out(mapMusic)
