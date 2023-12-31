extends Area2D

const PickUpSound = preload("res://Music and Sounds/KeyJingleSound.tscn")

var stats = PlayerStats


func _on_Key_area_entered(area):
		stats.keyLost = false
		stats.keys += 1
		stats.keys_collected += 1
		# print_debug(stats.keys)
		var pickUpSound = PickUpSound.instance()
		get_tree().current_scene.add_child(pickUpSound)
		# stats.emit_signal("keys_changed")
		queue_free()
