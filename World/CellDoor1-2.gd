extends StaticBody2D


onready var popup = $PopupDialog
var stats = PlayerStats
const CellDoorSound = preload("res://Music and Sounds/CellDoorSoundOne.tscn")

onready var save_file = SaveFile.g_data
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if save_file.cell_1_2_opened == true:
		queue_free()



func _process(delta):
	popup.rect_global_position = self.position


func _on_DoorEntry_area_entered(area):
	if stats.keys >= 1:
		stats.keyLost = true
		var cellDoorSound = CellDoorSound.instance()
		get_tree().current_scene.add_child(cellDoorSound)
		stats.keys -= 1
		stats.emit_signal("key_use")
		save_file.cell_1_2_opened = true
		queue_free()
	elif stats.keys == 0:
		popup.popup()


func _on_DoorEntry_area_exited(area):
	popup.hide()
