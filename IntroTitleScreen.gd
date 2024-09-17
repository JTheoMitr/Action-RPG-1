extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tween_out = $Tween
onready var music = $TitleMusic
onready var lightningTimer = $LightningTimer
onready var lightningOne = $LightningStrikeOne
onready var lightningTimerTwo = $LightningTimerTwo
onready var lightningTwo = $LightningStrikeOne2
onready var chimeOne = $Button1Sound
onready var chimeTwo = $Button2Sound
onready var popup = $CanvasLayer/PopupDialog
onready var popup2 = $CanvasLayer/PopupDialog2
onready var controlScreen = $CanvasLayer/ControlScreen
onready var demoOverview = $CanvasLayer/DemoOverviewScreen
onready var returnBtn = $CanvasLayer/Popup
onready var selectSound = $SelectSound
export var transition_duration = 2.00
export var transition_type = 1 # TRANS_SINE

var mute

func fade_out(stream_player):
	# tween music volume down to 0
	tween_out.interpolate_property(stream_player, "volume_db", -5, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	# when the tween ends, the music will be stopped

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Button.grab_focus()
	lightningOne.frame = 0
	lightningOne.hide()
	lightningTimer.start()
	lightningTwo.frame = 0
	lightningTwo.hide()
	lightningTimerTwo.start()
	controlScreen.hide()
	demoOverview.hide()
	mute = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#popup.rect_global_position = self.rect_global_position


func _on_Button_pressed():
	#SceneTransitionLong.change_scene("res://World.tscn")
	fade_out(music)
	chimeOne.play()
	#SceneTransitionLong.change_scene("res://World2.tscn")
	#SceneTransitionLong.change_scene("res://IntroStory.tscn")
	#SceneTransitionLong.change_scene("res://World.tscn")
	SceneTransitionLong.change_scene("res://UI/WorldMapScreen.tscn")
	


func _on_Button2_pressed():
	
	popup2.popup()


func _on_LightningTimer_timeout():
	lightningOne.show()
	lightningOne.play("default")


func _on_LightningStrikeOne_animation_finished():
	lightningOne.hide()
	lightningOne.stop()
	lightningOne.frame = 0



func _on_LightningTimerTwo_timeout():
	lightningTwo.show()
	lightningTwo.play("default")


func _on_LightningStrikeOne2_animation_finished():
	lightningTwo.hide()
	lightningTwo.stop()
	lightningTwo.frame = 0


func _on_Button3_pressed():
	popup.popup()


func _on_PopButton_pressed():
	popup.hide()


func _on_PopButton2_pressed():
	SaveFile.clear_save_file()
	popup.hide()


func _on_ControlsButton_pressed():
	chimeTwo.play()
	controlScreen.show()
	popup2.hide()
	returnBtn.popup()

	


func _on_TutorialButton_pressed():
	chimeTwo.play()
	SceneTransitionLong.change_scene("res://TutorialScreen.tscn")
	popup2.hide()


func _on_DemoButton_pressed():
	chimeTwo.play()
	demoOverview.show()
	popup2.hide()
	returnBtn.popup()


func _on_ReturnButton_pressed():
	controlScreen.hide()
	demoOverview.hide()
	returnBtn.hide()


func _on_Button_focus_entered():
	if mute == false:
		selectSound.play()


func _on_Button2_focus_entered():
	mute = false
	selectSound.play()


func _on_Button3_focus_entered():
	selectSound.play()


func _on_PopButton_focus_entered():
	selectSound.play()


func _on_PopButton2_focus_entered():
	selectSound.play()


func _on_ControlsButton_focus_entered():
	selectSound.play()


func _on_TutorialButton_focus_entered():
	selectSound.play()


func _on_DemoButton_focus_entered():
	selectSound.play()
