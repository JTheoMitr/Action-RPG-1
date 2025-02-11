extends Area2D

const PickUpSound = preload("res://Music and Sounds/PickUpSoundTwo.tscn")

onready var popup = $PopupDialog
onready var timer = $Timer

onready var save_file = SaveFile.g_data

var stats = PlayerStats
onready var sprite = $Sprite
onready var coll = $CollisionShape2D

func _process(delta):
	popup.rect_global_position.y = self.global_position.y + 5
	popup.rect_global_position.x = self.global_position.x - 8

func _on_Battery_area_entered(area):
	if stats.batteries < stats.max_batteries:
		stats.batteries += 1
		var pickUpSound = PickUpSound.instance()
		get_tree().current_scene.add_child(pickUpSound)
		timer.start()
		popup.show()
		sprite.hide()
		coll.call_deferred("queue_free")
	elif stats.batteries >= stats.max_batteries:
		stats.bluepops += 1
		var pickUpSound = PickUpSound.instance()
		get_tree().current_scene.add_child(pickUpSound)
		timer.start()
		popup.show()
		sprite.hide()
		coll.call_deferred("queue_free")



func _on_Timer_timeout():
	queue_free()
