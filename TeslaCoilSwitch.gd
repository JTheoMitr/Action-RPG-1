extends StaticBody2D

onready var switchArea = $SwitchArea2D
onready var popup = $PopupDialog
onready var spinCross = $Sprite3
onready var save_data = SaveFile.g_data

onready var button_anim = $PopupDialog/Sprite/AnimatedSprite
onready var ok_text = $PopupDialog/Sprite/RichTextLabel4
onready var ok_timer = $Timer3
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var worldStats = WorldStats
var playerStats = PlayerStats

var button_showing = false
var button_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Lightning1.hide()
	$Lightning2.hide()
	$Lightning3.hide()
	$Lightning4.hide()
	$Lightning5.hide()
	$Lightning6.hide()
	ok_text.hide()
	button_anim.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popup.rect_global_position.y = switchArea.global_position.y
	popup.rect_global_position.x = switchArea.global_position.x + 5
	spinCross.rotation_degrees += 2
	if button_showing:
		if button_pressed == false:
			if Input.is_action_just_pressed("roll"):
				popup.hide()
				$AlertArea2D/CollisionShape2D.disabled = true
				playerStats.emit_signal("player_resumed")
				$Timer2.start()
				button_pressed = true
			

func _on_SwitchArea2D_area_entered(area):
	#worldStats.emit_signal("portal_opened") #this is the signal to emit for 'soldier.explodes' in zoom method
	worldStats.emit_signal("pylon_activated")
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
		$WarningSound.play()
		playerStats.emit_signal("player_paused")
		ok_timer.start()


func _on_Timer2_timeout():
	popup.hide()
	$AlertArea2D/CollisionShape2D.disabled = false
	button_showing = false
	button_pressed = false
	ok_text.hide()
	button_anim.hide()


func _on_Timer3_timeout():
	ok_text.show()
	button_anim.show()
	button_showing = true
