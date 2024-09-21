extends StaticBody2D

onready var switchArea = $SwitchArea2D
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
#func _process(delta):
#	pass

func _on_SwitchArea2D_area_entered(area):
	worldStats.emit_signal("portal_purp2_opened")
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
