extends Area2D


onready var popup = $PopupDialog
onready var stats = PlayerStats
onready var worldStats = WorldStats
onready var collision = $CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	pass
	popup.rect_global_position.x = self.position.x + 10
	popup.rect_global_position.y = self.position.y + 60


func _on_TutorialArea1_area_entered(area):
	$AudioStreamPlayer.play()
	$Timer.start()
	stats.emit_signal("player_paused")
	popup.popup()
	print_debug(self.position.x)
	print_debug(self.position.y)
	print_debug($CollisionShape2D.position.x)
	print_debug($CollisionShape2D.position.y)

func _on_TutorialArea1_area_exited(area):
	pass
	#popup.hide()
	#queue_free()


func _on_VideoPlayer_finished():
	$PopupDialog/VideoPlayer.play()


func _on_Timer_timeout():
	stats.emit_signal("player_resumed")
	#yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
