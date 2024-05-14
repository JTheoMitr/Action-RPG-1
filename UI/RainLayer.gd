extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var darkSky = $DarkSkyLayer
onready var rain = $Rain
onready var lightning = $Lightning
onready var rainTimer = $RainTimer
onready var rainStopTimer = $RainStopTimer
onready var thunder = $Thunder
onready var rainSound = $RainSound


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
