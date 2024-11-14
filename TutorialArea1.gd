extends Area2D


onready var popup = $PopupDialog
onready var stats = PlayerStats
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	popup.rect_global_position.x = self.position.x
	popup.rect_global_position.y = self.position.y


func _on_TutorialArea1_area_entered(area):
	$AudioStreamPlayer.play()
	$Timer.start()
	popup.popup()

func _on_TutorialArea1_area_exited(area):
	pass
	#popup.hide()
	#queue_free()


func _on_VideoPlayer_finished():
	$PopupDialog/VideoPlayer.play()


func _on_Timer_timeout():
	
	queue_free()
