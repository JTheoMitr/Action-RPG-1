extends Area2D

const PickUpSound = preload("res://Music and Sounds/PickUpSoundTwo.tscn")

onready var popup = $PopupDialog
onready var timer = $Timer
onready var save_file = SaveFile.g_data

var stats = PlayerStats
var picked = false

func _process(delta):
	popup.rect_global_position.y = self.global_position.y + 5
	popup.rect_global_position.x = self.global_position.x - 8

func _on_Ammo_area_entered(area):
	if stats.ammo < stats.max_ammo && (picked == false):
		stats.ammo += 2
		var pickUpSound = PickUpSound.instance()
		get_tree().current_scene.add_child(pickUpSound)
		picked = true
		queue_free()
		
	elif stats.ammo == stats.max_ammo:
		timer.start()
		popup.show()


func _on_Timer_timeout():
	popup.hide()
