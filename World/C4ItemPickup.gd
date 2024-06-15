extends Area2D

const PickUpSound = preload("res://Music and Sounds/PickUpSoundThree.tscn")

onready var popup = $PopupDialog
onready var timer = $Timer

var stats = PlayerStats

func _process(delta):
	popup.rect_global_position.y = self.global_position.y + 5
	popup.rect_global_position.x = self.global_position.x - 8

func _on_Battery_area_entered(area):
	if stats.c4Acquired == false:
		popup.show()
		stats.c4Acquired = true
		self.hide()
		var pickUpSound = PickUpSound.instance()
		get_tree().current_scene.add_child(pickUpSound)
		timer.start()
	



func _on_Timer_timeout():
	queue_free()
