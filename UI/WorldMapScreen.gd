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
onready var mapMusic = $MapMusic
onready var timer = $Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	forestButton.grab_focus()
	mapMusic.play(0.0)
	selectSound.volume_db = -60
	timer.start(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if forestButton.has_focus():
		wolfIcon.position.x = 191
		wolfIcon.position.y = 159
		levelPreText.text = "The"
		levelText.text = "Forest"
	if caveButton.has_focus():
		wolfIcon.position.x = 171
		wolfIcon.position.y = 142
		levelPreText.text = "Wylde"
		levelText.text = "Caverns"
	if marshButton.has_focus():
		wolfIcon.position.x = 183
		wolfIcon.position.y = 112
		levelPreText.text = "Toad"
		levelText.text = "Marsh"
	if cityButton.has_focus():
		wolfIcon.position.x = 174
		wolfIcon.position.y = 66
		levelPreText.text = "Arcade"
		levelText.text = "Heights"
	if desertButton.has_focus():
		wolfIcon.position.x = 128
		wolfIcon.position.y = 85
		levelPreText.text = "The"
		levelText.text = "Desert"
	if blizzardButton.has_focus():
		wolfIcon.position.x = 152
		wolfIcon.position.y = 34
		levelPreText.text = "Blizzard"
		levelText.text = "Canyon"
		
		



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
