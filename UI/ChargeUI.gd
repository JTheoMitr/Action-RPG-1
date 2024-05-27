extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var purpCharge = $PurpCharge
onready var greenCharge = $GreenCharge
onready var redCharge = $RedCharge
onready var playerStats = PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready():
	purpCharge.show()
	greenCharge.hide()
	redCharge.hide()
	playerStats.connect("green_charged", self, "enable_green")
	playerStats.connect("red_charged", self, "enable_red")
	playerStats.connect("purple_charged", self, "enable_purple")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func enable_green():
	greenCharge.show()
	redCharge.hide()
	purpCharge.hide()
	
func enable_red():
	greenCharge.hide()
	redCharge.show()
	purpCharge.hide()
	
func enable_purple():
	greenCharge.hide()
	redCharge.hide()
	purpCharge.show()
