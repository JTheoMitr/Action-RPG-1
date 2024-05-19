extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var rage = $Rage
onready var lightning = $Lightning
onready var lightning2 = $Lightning2
onready var rageTimer = $RageTimer
onready var rageStopTimer = $RageStopTimer
onready var thunderSound = $Thunder
onready var thunderSound2 = $Thunder2
onready var lightningTimer = $LightningTimer
onready var hideTimer = $LightningHideTimer
onready var rageHideTimer = $RageHideTimer
onready var screenCrack = $ScreenCrack
onready var screenCrack2 = $ScreenCrack2
onready var screenCrack3 = $ScreenCrack3
onready var screenCrack4 = $ScreenCrack4
onready var screenCrack5 = $ScreenCrack5
onready var screenCrack6 = $ScreenCrack6
onready var crackSound1 = $GlassBreak
onready var crackSound2 = $GlassBreak2
onready var crackSound3 = $GlassBreak3
onready var glitchOut = $ScreenGlitch

var worldStats = WorldStats
var enraged = false




# Called when the node enters the scene tree for the first time.
func _ready():
	rage.hide()
	screenCrack.frame = 0
	screenCrack.hide()
	screenCrack.stop()
	screenCrack2.frame = 0
	screenCrack2.hide()
	screenCrack2.stop()
	screenCrack3.frame = 0
	screenCrack3.hide()
	screenCrack3.stop()
	screenCrack4.frame = 0
	screenCrack4.hide()
	screenCrack4.stop()
	screenCrack5.frame = 0
	screenCrack5.hide()
	screenCrack5.stop()
	screenCrack6.frame = 0
	screenCrack6.hide()
	screenCrack6.stop()
	rageTimer.wait_time = 0.1
	rage.modulate.a = 0.0
	worldStats.connect("rage_mode", self, "rage_time")
	#rage_mode now needs to be triggered from the Golem Boss's taunt before going berserk
	
func rage_time():
	screenCrack.show()
	screenCrack.play("boulder")
	var crackSound = random_drop_generator([crackSound1, crackSound2, crackSound3])
	crackSound.play()
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func _on_RageTimer_timeout():
	$Tween.interpolate_property(rage, "modulate:a", 0.0, 1.0, 2, Tween.TRANS_LINEAR)
	$Tween.start()
	rage.show()


func _on_RageStopTimer_timeout():
	$Tween.interpolate_property(rage, "modulate:a", 1.0, 0.0, 5, Tween.TRANS_LINEAR)
	$Tween.start()
	rageHideTimer.start()


func _on_RageHideTimer_timeout():
	rage.hide()
	screenCrack.frame = 0
	screenCrack.hide()
	screenCrack2.frame = 0
	screenCrack2.hide()
	screenCrack3.frame = 0
	screenCrack3.hide()
	screenCrack4.frame = 0
	screenCrack4.hide()
	screenCrack5.frame = 0
	screenCrack5.hide()
	screenCrack6.frame = 0
	screenCrack6.hide()
	enraged = false



func _on_ScreenCrack_animation_finished():
	screenCrack2.show()
	screenCrack2.play()
	var crackSound = random_drop_generator([crackSound1, crackSound2, crackSound3])
	crackSound.play()
	screenCrack.frame = 9


func _on_ScreenCrack2_animation_finished():
	screenCrack3.show()
	screenCrack3.play()
	var crackSound = random_drop_generator([crackSound1, crackSound2, crackSound3])
	crackSound.play()
	screenCrack2.frame = 9


func _on_ScreenCrack3_animation_finished():
	screenCrack4.show()
	screenCrack4.play()
	var crackSound = random_drop_generator([crackSound1, crackSound2, crackSound3])
	crackSound.play()
	screenCrack3.frame = 9


func _on_ScreenCrack4_animation_finished():
	screenCrack5.show()
	screenCrack5.play()
	var crackSound = random_drop_generator([crackSound1, crackSound2, crackSound3])
	crackSound.play()
	screenCrack4.frame = 9


func _on_ScreenCrack5_animation_finished():
	screenCrack6.show()
	screenCrack6.play()
	var crackSound = random_drop_generator([crackSound1, crackSound2, crackSound3])
	crackSound.play()
	screenCrack5.frame = 9


func _on_ScreenCrack6_animation_finished():
	screenCrack6.frame = 9
	rageTimer.start()
	rageStopTimer.start()
	enraged = true
