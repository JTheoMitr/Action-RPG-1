extends AnimatedSprite

onready var click = $Click
var worldStats = WorldStats
var clicked
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.frame = 0
	clicked = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	
	self.frame = 1
	if clicked == false:
		click.play(0.0)
		worldStats.emit_signal("open_fence_two")
		clicked = true
	
	


func _on_Click_finished():
	click.volume_db = -70
