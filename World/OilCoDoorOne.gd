extends StaticBody2D


const HumSound = preload("res://Music and Sounds/ElectricHumOne.tscn")

onready var popup = $PopupDialog
onready var spooky = $SpookyBells
onready var timer = $Timer
onready var humSound = HumSound.instance()
var worldStats = WorldStats


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spooky.volume_db <= -25:
		timer.stop()
	popup.rect_global_position.x = self.position.x + 30
	popup.rect_global_position.y = self.position.y


func _on_Area2D_area_entered(area):
	spooky.volume_db = -5
	get_tree().current_scene.add_child(humSound)
	worldStats.emit_signal("fade_music_out")
	spooky.play(0.0)
	popup.popup()


func _on_Area2D_area_exited(area):
	timer.start()
	worldStats.emit_signal("fade_music_in")
	popup.hide()
	get_tree().current_scene.remove_child(humSound)

func _on_Timer_timeout():
	spooky.volume_db -= 1
