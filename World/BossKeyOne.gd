extends Area2D

const PickUpSound = preload("res://Music and Sounds/BossKeySound.tscn")
var stats = PlayerStats

onready var save_data = SaveFile.g_data
# Called when the node enters the scene tree for the first time.
func _ready():
	if save_data.boss_key_1_nabbed == true:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BossKeyOne_area_entered(area):
	stats.boss_keys += 1
	save_data.boss_key_1_nabbed = true
	SaveFile.save_data()
	var pickUpSound = PickUpSound.instance()
	get_tree().current_scene.add_child(pickUpSound)
	stats.emit_signal("boss_key_acquired")
	#stats.emit_signal("player_paused")
	queue_free()
