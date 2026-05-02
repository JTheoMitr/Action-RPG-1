extends Area2D


onready var popup = $PopupDialog
onready var spin_cube = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	popup.rect_global_position.x = self.position.x
	popup.rect_global_position.y = self.position.y
	
	if popup.visible:
		spin_cube.visible = false
	else:
		spin_cube.visible = true


func _on_TutorialArea2_area_entered(area):
	popup.popup()
	


func _on_TutorialArea2_area_exited(area):
	popup.hide()
	
	#queue_free()
