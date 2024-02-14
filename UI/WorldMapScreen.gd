extends ColorRect

onready var wolfIcon = $WhiteWolf
onready var forestButton = $ForestButton
onready var caveButton = $CaveButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	forestButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if forestButton.has_focus():
		wolfIcon.position.x = 191
		wolfIcon.position.y = 159
	if caveButton.has_focus():
		wolfIcon.position.x = 171
		wolfIcon.position.y = 142

