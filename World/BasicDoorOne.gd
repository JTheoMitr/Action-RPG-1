extends StaticBody2D

const DoorDust = preload("res://Effects/DoorDustEffectOne.tscn")
const DoorCreak = preload("res://Music and Sounds/DoorCreak.tscn")
onready var popup = $PopupDialog
onready var worldStats = WorldStats
onready var save_file = SaveFile.g_data


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var stats = PlayerStats


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position = self.position


func create_dust_effect():
	var dustEffect = DoorDust.instance()
	get_parent().add_child(dustEffect)
	dustEffect.global_position.x = global_position.x
	dustEffect.global_position.y = global_position.y + 25
	
func _on_Area2D_area_entered(area):
	if save_file.boss_key_1_nabbed && save_file.forest_bear_saved && save_file.forest_deer_saved && save_file.forest_bunny_saved: #check this for exit issues, change WorldStats to an onready var
		create_dust_effect()
		#stats.boss_keys -= 1
		#stats.forest_freed -= 3
		#stats.keys_collected -= 3
		save_file.world_1_path_opened = true
		SaveFile.save_data()
		var creakSound = DoorCreak.instance()
		get_tree().current_scene.add_child(creakSound)
		queue_free()
	else:
		popup.popup()
		print_debug(stats.boss_keys)
		print_debug(stats.forest_freed)
		


func _on_Area2D_area_exited(area):
	popup.hide()
