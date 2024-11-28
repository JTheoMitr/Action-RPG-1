extends Area2D


onready var popup = $PopupDialog
var unplayed

# Called when the node enters the scene tree for the first time.
func _ready():
	unplayed = true
	
func _process(delta):
	popup.rect_global_position.x = self.position.x
	popup.rect_global_position.y = self.position.y


func _on_TutorialArea2_area_entered(area):
	popup.popup()
	if unplayed:
		$AudioStreamPlayer.play()


func _on_TutorialArea2_area_exited(area):
	popup.hide()
	unplayed = false

