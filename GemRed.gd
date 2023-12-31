extends KinematicBody2D

const CoinSound = preload("res://Music and Sounds/CoinSound.tscn")


var stats = PlayerStats

func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	stats.coins += 1
	var pickUpSound = CoinSound.instance()
	get_tree().current_scene.add_child(pickUpSound)
	queue_free()
