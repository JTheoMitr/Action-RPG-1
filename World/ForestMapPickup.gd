extends Area2D

const PickUpSound = preload("res://Music and Sounds/KeyJingleSound.tscn")

var stats = PlayerStats

onready var save_file = SaveFile.g_data

func _ready():
	if save_file != null:
		if save_file.forestMapPickedUp == true:
			queue_free()


func _on_Key_area_entered(area):
		stats.forestMapFound = true
		save_file.forestMapPickedUp = true
		var pickUpSound = PickUpSound.instance()
		get_tree().current_scene.add_child(pickUpSound)
		stats.emit_signal("map_pickup")
		SaveFile.save_data()
		queue_free()
