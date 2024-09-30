extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var effectsAnim = $EffectsAnim
onready var zoomOff = $ZoomOff
onready var zoomOn = $ZoomOn
onready var zoomTimer = $Timer
onready var zoomOffTimer = $Timer2

# Called when the node enters the scene tree for the first time.
func _ready():
	zoomOn.hide()
	zoomOff.show()
	effectsAnim.frame = 0
	effectsAnim.stop()
	effectsAnim.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("roll"):
		zoomTimer.start(0.0)
		
	if Input.is_action_just_released("roll"):
		zoomTimer.stop()
		zoomOn.hide()
		effectsAnim.frame = 0
		effectsAnim.stop()
		effectsAnim.hide()
		



func _on_Timer_timeout():
	zoomOn.show()
	effectsAnim.show()
	effectsAnim.play("default")
	zoomOffTimer.start(0.0)
	



func _on_Timer2_timeout():
	zoomOn.hide()
	effectsAnim.frame = 0
	effectsAnim.stop()
	effectsAnim.hide()
