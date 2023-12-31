extends StaticBody2D


const HumSound = preload("res://Music and Sounds/ElectricHumOne.tscn")

onready var popup = $PopupDialog
var humSound = HumSound.instance()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position.x = self.position.x + 30
	popup.rect_global_position.y = self.position.y


func _on_Area2D_area_entered(area):
	get_tree().current_scene.add_child(humSound)
	popup.popup()


func _on_Area2D_area_exited(area):
	popup.hide()
	get_tree().current_scene.remove_child(humSound)
