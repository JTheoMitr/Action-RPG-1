extends Area2D


onready var popup = $PopupDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	popup.rect_global_position.x = self.position.x
	popup.rect_global_position.y = self.position.y



func _on_TutorialArea1_2_area_entered(area):
	# bypass for demo
	pass
	
	# popup.popup()


func _on_TutorialArea1_2_area_exited(area):
	popup.hide()
	#queue_free()

