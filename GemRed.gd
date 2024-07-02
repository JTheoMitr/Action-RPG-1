extends KinematicBody2D

const CoinSound = preload("res://Music and Sounds/CoinSound.tscn")

onready var save_file = SaveFile.g_data

var stats = PlayerStats

func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	stats.coins += 1
	#save_file.player_coins += 1
	SaveFile.save_data()
	var pickUpSound = CoinSound.instance()
	get_tree().current_scene.add_child(pickUpSound)
	queue_free()
