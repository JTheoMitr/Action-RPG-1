extends Node2D

const MushroomSquanch = preload("res://Effects/MushroomSquanchTwo.tscn")
const SquanchSound = preload("res://Music and Sounds/SquishSound.tscn")
const SquishSound = preload("res://Music and Sounds/SquishSound2.tscn")
var squanch = MushroomSquanch.instance()
onready var sprite = $Sprite
onready var worldStats = WorldStats
onready var stats = PlayerStats
const ToxicEffect = preload("res://Effects/ToxicMushieEffect.tscn")


func _ready():
	pass # Replace with function body.


func create_squanch():
	get_parent().add_child(squanch)
	squanch.global_position = global_position
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

func _on_Hurtbox_area_entered(_area):
	create_squanch()
	stats.health -= 1
	var squishSound = SquanchSound.instance()
	var squishSound2 = SquishSound.instance()
	var squished = random_drop_generator([squishSound, squishSound2])
	get_tree().current_scene.add_child(squished)
	var cloud = ToxicEffect.instance()
	get_tree().current_scene.add_child(cloud)
	cloud.global_position = sprite.global_position
	worldStats.emit_signal("bad_trip")
	queue_free()
