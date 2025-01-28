extends Area2D

const PickUpSound = preload("res://Music and Sounds/PickUpSoundThree.tscn")

var stats = PlayerStats

onready var popup = $PopupDialog
onready var timer = $Timer
onready var sprite = $Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position.y = self.global_position.y + 10
	popup.rect_global_position.x = self.global_position.x - 5


func _on_Timer_timeout():
	popup.hide()
	queue_free()


func _on_Syringe1_area_entered(area):
	sprite.hide()
	var pickUpSound = PickUpSound.instance()
	get_tree().current_scene.add_child(pickUpSound)
	timer.start()
	popup.show()
