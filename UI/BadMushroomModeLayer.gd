extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var shroomin = $Shroomin
onready var shroomTimer = $ShroomTimer
onready var trippinSound = $TrippinSound
onready var hideTimer = $HideTimer
onready var worldStats = WorldStats

var shroomsOn = false



# Called when the node enters the scene tree for the first time.
func _ready():
	worldStats.connect("bad_trip", self, "show_shrooms")
	self.hide()
	shroomTimer.wait_time = 5
	trippinSound.volume_db = -30.0

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_shrooms():
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 2, Tween.TRANS_LINEAR)
	#$Tween.start()
	self.show()
	shroomTimer.start()
	$Tween.interpolate_property(trippinSound, "volume_db", -30.0, -5.0, 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
	trippinSound.play()
	worldStats.emit_signal("fade_music_out")

func _on_ShroomTimer_timeout():
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 2, Tween.TRANS_LINEAR)
	#$Tween.start()
	hideTimer.start()
	$Tween.interpolate_property(trippinSound, "volume_db", -5.0, -30.0, 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
	worldStats.emit_signal("fade_music_in")


func _on_HideTimer_timeout():
	self.hide()
	trippinSound.stop()
