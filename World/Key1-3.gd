extends Area2D

const PickUpSound = preload("res://Music and Sounds/KeyJingleSound.tscn")

var stats = PlayerStats

onready var save_file = SaveFile.g_data

func _ready():
	if save_file.key1_3_nabbed == true:
		queue_free()

func _on_Key_area_entered(area):
		stats.keyLost = false
		stats.keys += 1
		#save_file.player_keys += 1
		stats.keys_collected += 1
		# print_debug(stats.keys)
		var pickUpSound = PickUpSound.instance()
		get_tree().current_scene.add_child(pickUpSound)
		stats.emit_signal("key_pickup")
		save_file.key1_3_nabbed = true
		queue_free()
