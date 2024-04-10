extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var purpCharge = $PurpCharge
onready var greenCharge = $GreenCharge
onready var redCharge = $RedCharge

# Called when the node enters the scene tree for the first time.
func _ready():
	purpCharge.show()
	greenCharge.hide()
	redCharge.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
