extends Area2D

onready var popup = $IntroDialog1
onready var stats = PlayerStats
onready var save_data = SaveFile.g_data

var inArea = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if save_data.forest_bunny_saved == true:
		queue_free()
	
func _process(delta):
	popup.rect_global_position.x = self.position.x - 75
	popup.rect_global_position.y = self.position.y - 15
	
	if (inArea == true) && Input.is_action_just_pressed("interact"):
		stats.emit_signal("player_resumed")
		popup.hide()
		queue_free()


func _on_IntroArea_area_entered(area):
	popup.popup()
	inArea = true
	stats.emit_signal("player_paused")

