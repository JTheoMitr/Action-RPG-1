extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var fog1 = $Fog
onready var fog2 = $Fog2

onready var dissipateTimer = $Timer
onready var fogUpTimer = $Timer2

var fogFading
var fogRising

# Called when the node enters the scene tree for the first time.
func _ready():
	fog1.rect_position.x = 0
	fog2.rect_position.x = 751
	print_debug(fog1.modulate.a)
	fogFading = false
	fogRising = true

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fog1.rect_position.x -= .1
	#fog2.rect_position.x -= .1
	if fog1.rect_position.x <= -400 && fogRising:
		fogRising = false
		fogFading = true
		dissipateTimer.start()
		fogUpTimer.stop()
		
	if fog1.modulate.a <= 0 && fogFading:
		fogRising = true
		fogFading = false
		fogUpTimer.start()
		dissipateTimer.stop()
	
	if fog1.rect_position.x <= -420:
		fog1.rect_position.x = 0
		
		
		
		
		
	if fog2.rect_position.x <= -600:
		fog2.rect_position.x = fog1.rect_position.x + 751
	


func _on_Timer_timeout():
	if fog1.modulate.a > 0.0:
		fog1.modulate.a -= .1


func _on_Timer2_timeout():
	if fog1.modulate.a < 0.78:
		fog1.modulate.a += .1
