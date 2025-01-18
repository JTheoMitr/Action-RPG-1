extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var fog1 = $Fog
onready var fog2 = $Fog2


# Called when the node enters the scene tree for the first time.
func _ready():
	fog1.rect_position.x = 0
	fog2.rect_position.x = 321

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fog1.rect_position.x -= .1
	#fog2.rect_position.x -= .1
	
	if fog1.rect_position.x <= -321:
		fog1.rect_position.x = 0
	#if fog2.rect_position.x <= -321:
	#	fog2.rect_position.x = 321
	
