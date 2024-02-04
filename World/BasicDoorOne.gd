extends StaticBody2D

const DoorDust = preload("res://Effects/DoorDustEffectOne.tscn")
const DoorCreak = preload("res://Music and Sounds/DoorCreak.tscn")
onready var popup = $PopupDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var stats = PlayerStats


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_dust_effect():
	var dustEffect = DoorDust.instance()
	get_parent().add_child(dustEffect)
	dustEffect.global_position.x = global_position.x
	dustEffect.global_position.y = global_position.y + 25
	
func _on_Area2D_area_entered(area):
	if stats.boss_keys == 1 && WorldStats.freed == 3: #check this for exit issues, change WorldStats to an onready var
		create_dust_effect()
		var creakSound = DoorCreak.instance()
		get_tree().current_scene.add_child(creakSound)
		queue_free()
	else:
		popup.popup()
		print_debug(stats.boss_keys)
		print_debug(WorldStats.freed)
		


func _on_Area2D_area_exited(area):
	popup.hide()
