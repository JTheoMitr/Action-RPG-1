extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var podiumSprite = $AnimatedSprite
onready var click = $Click1
onready var beep = $Beep1
# Called when the node enters the scene tree for the first time.
func _ready():
	podiumSprite.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	podiumSprite.frame = 1
	click.play()
	beep.play()
