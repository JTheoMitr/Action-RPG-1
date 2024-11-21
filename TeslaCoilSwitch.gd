extends StaticBody2D

onready var switchArea = $SwitchArea2D
onready var popup = $PopupDialog
onready var save_data = SaveFile.g_data
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var worldStats = WorldStats

# Called when the node enters the scene tree for the first time.
func _ready():
	$Lightning1.hide()
	$Lightning2.hide()
	$Lightning3.hide()
	$Lightning4.hide()
	$Lightning5.hide()
	$Lightning6.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position.y = switchArea.global_position.y
	popup.rect_global_position.x = switchArea.global_position.x + 5

func _on_SwitchArea2D_area_entered(area):
	worldStats.emit_signal("portal_opened")
	$Lightning1.show()
	$Lightning2.show()
	$Lightning3.show()
	$Lightning4.show()
	$Lightning5.show()
	$Lightning6.show()
	$AudioStreamPlayer.play()
	$Timer.start()


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.stop()


func _on_Timer_timeout():
	$Lightning1.queue_free()
	$Lightning2.queue_free()
	$Lightning3.queue_free()
	$Lightning4.queue_free()
	$Lightning5.queue_free()
	$Lightning6.queue_free()
	$AudioStreamPlayer.queue_free()


func _on_AlertArea2D_area_entered(area):
	if save_data.portal_1_opened == false:
		popup.popup()
		$Timer2.start()
		$WarningSound.play()


func _on_Timer2_timeout():
	popup.hide()
	$AlertArea2D/CollisionShape2D.disabled = true
