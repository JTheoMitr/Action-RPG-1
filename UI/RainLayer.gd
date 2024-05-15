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
onready var hideTimer = $LightningHideTimer
onready var rainHideTimer = $RainHideTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	rainTimer.wait_time = random_drop_generator([35, 40, 45])
	rainTimer.start(0.0)
	lightning.hide()
	lightning2.hide()
	rain.hide()
	rain.modulate.a = 0.0
	darkSky.hide()
	darkSky.color = Color(0,0,0,0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

func _on_RainTimer_timeout():
	
	lightningTimer.wait_time = 2
	thunderTimer.wait_time = lightningTimer.wait_time + 1
	rainStopTimer.wait_time = random_drop_generator([30, 45, 90])
	$Tween.interpolate_property(darkSky, "color", Color(0, 0, 0, 0), Color(0, 0, 0, 0.3), 2, Tween.TRANS_LINEAR)
	$Tween2.interpolate_property(rain, "modulate:a", 0.0, 1.0, 2, Tween.TRANS_LINEAR)
	$Tween.start()
	$Tween2.start()
	rainSound.play(0.0)
	thunderTimer.start()
	lightningTimer.start()
	darkSky.show()
	rain.show()


func _on_RainSound_finished():
	rainSound.play(0.0)


func _on_ThunderTimer_timeout():
	var thunder = random_drop_generator([thunderSound, thunderSound2])
	thunder.play()
	lightningTimer.wait_time = random_drop_generator([10, 15, 20])
	thunderTimer.wait_time = lightningTimer.wait_time + 1
	thunderTimer.start()
	lightningTimer.start()


func _on_LightningTimer_timeout():
	var flash = random_drop_generator([lightning, lightning2])
	flash.show()
	hideTimer.start()
	


func _on_LightningHideTimer_timeout():
	lightning.hide()
	lightning2.hide()


func _on_RainStopTimer_timeout():
	thunderTimer.stop()
	lightningTimer.stop()
	$Tween.interpolate_property(darkSky, "color", Color(0, 0, 0, 0.3), Color(0, 0, 0, 0), 2, Tween.TRANS_LINEAR)
	$Tween2.interpolate_property(rain, "modulate:a", 1.0, 0.0, 2, Tween.TRANS_LINEAR)
	$Tween.start()
	$Tween2.start()
	rainHideTimer.start()


func _on_RainHideTimer_timeout():
	rain.hide()
	darkSky.hide()
	rainSound.stop()
