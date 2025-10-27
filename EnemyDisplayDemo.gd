extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const BLRS = preload("res://Enemies/BossLaserRightStraight.tscn")
const BLTRS = preload("res://Enemies/BossLaserTopRightStraight.tscn")
const BLBRS = preload("res://Enemies/BossLaserBottomRightStraight.tscn")

onready var sprite4 = $Sprite4
onready var sprite5 = $Sprite5
onready var firePoint = $AnimatedSprite/Area2D/CollisionShape2D
onready var firePoint2 = $AnimatedSprite2/Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite4.global_position.x -= .1
	sprite5.global_position.x -= .1


func _on_Button_pressed():
	#SceneTransitionLong.change_scene("res://IntroTitleScreen.tscn")
	self.hide()


func _on_Timer_timeout():
	var laser = BLRS.instance()
	get_parent().add_child(laser)
	laser.global_position = firePoint.global_position


func _on_Timer2_timeout():
	var laser = BLRS.instance()
	get_parent().add_child(laser)
	laser.global_position = firePoint2.global_position
	var laser2 = BLTRS.instance()
	get_parent().add_child(laser2)
	laser2.global_position = firePoint2.global_position
	var laser3 = BLBRS.instance()
	get_parent().add_child(laser3)
	laser3.global_position = firePoint2.global_position
