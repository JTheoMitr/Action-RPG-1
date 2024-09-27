extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var door = $Door
onready var endTimer = $Timer
onready var slideTimer = $Timer2
onready var slideTimerRight = $Timer3
onready var dustEffect1 = $DoorDustEffectOne
onready var lightFlash = $Panel2
onready var redFlash = $Panel3
onready var flashTimer = $Timer4
onready var saveTimer = $Timer5
onready var saveTimer2 = $Timer6
onready var popUpSave = $PopupDialog
onready var click = $Click
onready var groan = $Groan
onready var steam = $Steam
onready var error = $Error
onready var spawnArea = $SpawnArea/CollisionShape2D
onready var save_data = SaveFile.g_data

onready var stats = PlayerStats

const CashSound = preload("res://Music and Sounds/CashRegisterSound.tscn")

var colorAdjustmentsLeft = false

# Called when the node enters the scene tree for the first time.
func _ready():
	dustEffect1.hide()
	popUpSave.hide()
	lightFlash.hide()
	redFlash.hide()
	print_debug((get_parent().get_parent().get_parent()).to_string()) #checking for level
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	popUpSave.rect_global_position = self.global_position
	if door.position.x > 3:
		slideTimerRight.stop()
	if door.position.x < -71:
		slideTimer.stop()
	


func _on_SaveChamber_area_entered(area):
	endTimer.start()
	slideTimer.start()
	slideTimerRight.stop()
	dustEffect1.show()
	groan.play()
	steam.play()



func _on_Timer2_timeout():
	if door.position.x > -71:
		door.global_position.x -= 1


func _on_Timer_timeout():
	#slideTimer.stop()
	#slideTimerRight.stop()
	dustEffect1.hide()


func _on_Timer3_timeout():
	if door.position.x < 3:
		door.global_position.x += 1


func _on_SaveChamber_area_exited(area):
	slideTimerRight.start()
	slideTimer.stop()
	endTimer.start()
	dustEffect1.show()
	groan.play()
	steam.play()
	


func _on_SaveZone2D_area_entered(area):
	if stats.coins >= 5:
		lightFlash.show()
		$PopupDialog/RichTextSave.bbcode_text = "[center]Game Saved"
		$PopupDialog/RichTextSave2.bbcode_text = "[center] -5"
		click.play()
		flashTimer.start()
		print_debug(self.global_position)
		#SaveFile.save_data()
	else:
		redFlash.show()
		$PopupDialog/RichTextSave.bbcode_text = "[center]Not Enough"
		$PopupDialog/RichTextSave2.bbcode_text = "     Need"
		error.play()
		flashTimer.start()


func _on_Timer4_timeout():
	lightFlash.hide()
	redFlash.hide()
	saveTimer.start()


func _on_Timer5_timeout():
	if stats.coins >= 5:
		popUpSave.popup()
		saveTimer2.start()
		stats.coins -= 5
		save_data.position_saved = true
		save_data.player_position_x = spawnArea.global_position.x
		save_data.player_position_y = spawnArea.global_position.y
		save_data.current_world = (get_parent().get_parent().get_parent()).to_string()
		var cashSound = CashSound.instance()
		get_parent().add_child(cashSound)
		SaveFile.save_data()
	else:
		popUpSave.popup()
		saveTimer2.start()
	

func _on_Timer6_timeout():
	popUpSave.hide()


func _on_Timer7_timeout():
	if colorAdjustmentsLeft == false:
		colorAdjustmentsLeft = true
	else:
		colorAdjustmentsLeft = false


func _on_Timer8_timeout():
	if colorAdjustmentsLeft:
		$RichTextSave2.self_modulate.b += .1
		$RichTextSave2.self_modulate.g += .1
	else:
		$RichTextSave2.self_modulate.b -= .1
		$RichTextSave2.self_modulate.g -= .1
