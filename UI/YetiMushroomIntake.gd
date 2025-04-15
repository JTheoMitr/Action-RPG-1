extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var topPanel = $TopCoverPanel
onready var bottomPanel = $BottomCoverPanel
onready var timer = $Timer
onready var panelTimer = $PanelTimer
onready var shroom = $Sprite
onready var pushRightTimer = $PushRightTimer
onready var stopRightTimer = $StopRightTimer
onready var text = $Panel3/RichTextLabel
onready var text2 = $Panel3/RichTextLabel2
onready var trippy1 = $AnimatedSprite
onready var trippy2 = $AnimatedSprite2
onready var switchTimer = $SwitchTimer
onready var eye = $Eye
onready var spinTimer = $SpinTimer
onready var cover = $Panel4
onready var endTimer = $EndTimer

var switchin
var pushinRight
var pushinLeft
var spin
var textFadeUp
var textFadeDown
var textVanish
var open
var ending
var hidden
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	spin = false
	pushinRight = false
	pushinLeft = false
	text.modulate.a = 0.0
	text2.modulate.a = 0.0
	eye.frame = 0
	cover.modulate.a = 0.0
	hidden = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spin:
		shroom.rotation_degrees += 2
		if eye.modulate.a >= 0.01:
			eye.modulate.a -= 0.01
		
	if bottomPanel.rect_position.y >= 100:
		if hidden == false:
			text.hide()
			hidden = true
		
	if switchin:
		trippy1.modulate.a -= 0.01
		
	if textFadeUp:
		if text.modulate.a <= 0.99:
			text.modulate.a += 0.01
		
	if textFadeDown:
		if text2.modulate.a <= 0.99:
			text2.modulate.a += 0.01
		if text.modulate.a >= 0.01:
			text.modulate.a -= 0.01
		
	if textVanish:
		if text2.modulate.a >= 0.01:
			text2.modulate.a -= 0.01
		#shroom.modulate.a -= 0.01
		
	if ending:
		if cover.modulate.a <= 0.99:
			cover.modulate.a += 0.01
		text.bbcode_text = "[center]You've survived another vision"
		text2.bbcode_text = "[center]+500 XP"
		text.modulate.a += 0.015
		text2.modulate.a += 0.015
		text.show()
		eye.modulate.a = 1.0
		eye.play("default")
		
		
		


func _on_Timer_timeout():
	panelTimer.start()
	switchTimer.start()


func _on_PanelTimer_timeout():
	if topPanel.rect_position.y >= -200:
		topPanel.rect_position.y -= 2
	if bottomPanel.rect_position.y <= 200:
		bottomPanel.rect_position.y += 2
		# to test -> change the transition in one of the worldMap levels 



func _on_SwitchTimer_timeout():
	switchin = true
	
	


func _on_FadeTimer1_timeout():
	textFadeUp = true
	print_debug("fade1")


func _on_FadeTimer2_timeout():
	textFadeDown = true
	textFadeUp = false
	eye.play("default")
	print_debug("fade2")


func _on_FadeTimer3_timeout():
	textVanish = true
	textFadeDown = false
	spinTimer.start()
	print_debug("vanish")
	endTimer.start()


func _on_Eye_animation_finished():
	eye.stop()
	eye.frame = 3


func _on_SpinTimer_timeout():
	spin = true


func _on_EndTimer_timeout():
	ending = true
	textVanish = false
	textFadeDown = false
	eye.frame = 0
	
