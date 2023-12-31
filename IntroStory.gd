extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var introTune = $IntroStorySong
onready var fadeTimer = $FadeTimer
onready var mainTimer = $MainTimer
onready var forest = $Forest
onready var cliffTanks = $CliffTanks
onready var refineries = $Refineries
onready var ceo = $CEO
onready var winterBirch = $WinterBirch
onready var theReturn = $TheReturn
onready var musicTimer = $MusicTimer
var sceneCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	introTune.play(7.0)
	cliffTanks.modulate.a = 0.0
	refineries.modulate.a = 0.0
	ceo.modulate.a = 0.0
	winterBirch.modulate.a = 0.0
	theReturn.modulate.a = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Timer_timeout():
	forest.modulate.a -= 0.05
	if sceneCount == 1 && cliffTanks.modulate.a <= 1:
		cliffTanks.modulate.a += 0.05
	if sceneCount == 2 && refineries.modulate.a <= 1:
		cliffTanks.modulate.a -= 0.05
		refineries.modulate.a += 0.05
	if sceneCount == 3 && ceo.modulate.a <= 1:
		refineries.modulate.a -= 0.05
		ceo.modulate.a += 0.05
	if sceneCount == 4 && winterBirch.modulate.a <= 1:
		ceo.modulate.a -= 0.05
		winterBirch.modulate.a += 0.05
	if sceneCount == 5 && theReturn.modulate.a <= 1:
		winterBirch.modulate.a -= 0.05
		theReturn.modulate.a += 0.05
	if sceneCount >= 6:
		introTune.volume_db -= 0.05
		SceneTransitionLong.change_scene("res://World.tscn")
		


func _on_Timer2_timeout():
	sceneCount += 1
	fadeTimer.start()


func _on_MusicTimer_timeout():
	if (introTune.volume_db <= 0.95):
		introTune.volume_db += 0.05
	if (introTune.volume_db >= 1):
		musicTimer.stop
