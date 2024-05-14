extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var darkSky = $DarkSkyLayer
onready var rain = $Rain
onready var lightning = $Lightning
onready var lightning2 = $Lightning2
onready var rainTimer = $RainTimer
onready var rainStopTimer = $RainStopTimer
onready var thunderSound = $Thunder
onready var thunderSound2 = $Thunder2
onready var rainSound = $RainSound
onready var lightningTimer = $LightningTimer
onready var thunderTimer = $ThunderTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	rainTimer.wait_time = random_drop_generator([15, 20, 25])
	rainTimer.start(0.0)
	lightning.hide()
	lightning2.hide()
	rain.hide()
	darkSky.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

func _on_RainTimer_timeout():
	var thunder = random_drop_generator([thunderSound, thunderSound2])
	rainStopTimer.wait_time = random_drop_generator([15, 30, 45])
	$Tween.interpolate_property(darkSky, "color", Color(0, 0, 0, 0), Color(0, 0, 0, 0.3), 2, Tween.TRANS_LINEAR)
	$Tween.start()
	rainSound.play(0.0)
	thunder.play(0.0)
	darkSky.show()
	rain.show()


func _on_RainSound_finished():
	rainSound.play(0.0)
