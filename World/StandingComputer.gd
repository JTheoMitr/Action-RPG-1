extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var beeps = $Beeps
onready var volumeTimer = $VolumeTimer
var fadeUp
var fadeDown
var stopped
# Called when the node enters the scene tree for the first time.
func _ready():
	beeps.volume_db = -36
	fadeUp = true
	fadeDown = false
	stopped = true
	volumeTimer.stop()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if beeps.volume_db >= -5 && stopped == false:
		volumeTimer.stop()
		stopped = true
	if beeps.volume_db <= -36 && stopped == false:
		volumeTimer.stop()
		beeps.stop()
		stopped = true


func _on_Area2D_area_entered(area):
	volumeTimer.start()
	stopped = false
	fadeUp = true
	fadeDown = false
	beeps.play()


func _on_VolumeTimer_timeout():
	if fadeUp && beeps.volume_db <= -6:
		beeps.volume_db += 1
	if fadeDown && beeps.volume_db >= -35:
		beeps.volume_db -= 1


func _on_Area2D_area_exited(area):
	stopped = false
	volumeTimer.start()
	fadeUp = false
	fadeDown = true
	

