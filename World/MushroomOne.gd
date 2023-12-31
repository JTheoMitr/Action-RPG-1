extends Node2D

const MushroomSquanch = preload("res://Effects/MushroomSquanch.tscn")
const SquanchSound = preload("res://Music and Sounds/SquishSound.tscn")
const SquishSound = preload("res://Music and Sounds/SquishSound2.tscn")
var squanch = MushroomSquanch.instance()


func _ready():
	pass # Replace with function body.


func create_squanch():
	get_parent().add_child(squanch)
	squanch.global_position = global_position
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

func _on_Hurtbox_area_entered(area):
	create_squanch()
	
	var squishSound = SquanchSound.instance()
	var squishSound2 = SquishSound.instance()
	var squished = random_drop_generator([squishSound, squishSound2])
	get_tree().current_scene.add_child(squished)
	queue_free()
