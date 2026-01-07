extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = $Timer
onready var text = $SmokeShopSign
onready var neon = $SmokeShopSignGlow

var glow_on
var glow_off
# Called when the node enters the scene tree for the first time.
func _ready():
	glow_on = true
	glow_off = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if glow_on:
		glow_on = false
		glow_off = true
		neon.hide()
		text.add_color_override("default_color", Color.black)
		print_debug("glowoff")
	else:
		glow_on = true
		glow_off = false
		neon.show()
		text.add_color_override("default_color", Color.chartreuse)
		print_debug("glowon")
