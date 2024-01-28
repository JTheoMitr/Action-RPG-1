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
onready var musicTimer2 = $MusicTimer2
onready var transitionTimer = $TransitionTimer
var sceneCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	introTune.play(7.5)
	introTune.volume_db = - 20.0
	cliffTanks.modulate.a = 0.0
	refineries.modulate.a = 0.0
	ceo.modulate.a = 0.0
	winterBirch.modulate.a = 0.0
	theReturn.modulate.a = 0.0
	musicTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_pause") || Input.is_action_just_pressed("interact"):
		mainTimer.stop() # to avoid a double fade-in for world 1
		musicTimer2.start()
		fadeTimer.stop()
		transitionTimer.start()




func _on_Timer_timeout():
	print_debug(sceneCount)
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
		mainTimer.stop() # to avoid a double fade-in for world 1
		musicTimer2.start()
		fadeTimer.stop()
		transitionTimer.start()
		
		


func _on_Timer2_timeout():
	sceneCount += 1
	fadeTimer.start()


func _on_MusicTimer_timeout():
	if (introTune.volume_db <= 0):
		introTune.volume_db += 1
	if (introTune.volume_db > 0):
		musicTimer.stop()


func _on_MusicTimer2_timeout():
	if (introTune.volume_db <= 1.95):
		introTune.volume_db -= 1


func _on_TransitionTimer_timeout():
	SceneTransitionLong.change_scene("res://World.tscn")
	print_debug("whattttt")
