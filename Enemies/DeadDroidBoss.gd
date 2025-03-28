extends StaticBody2D

onready var timer = $Timer
onready var sprite = $DeadBotSprite
onready var destructTimer = $DestructTimer
onready var popupD = $PopupDestruct
onready var explosionAnim = $AnimatedSprite
onready var destructMsg = $PopupDestruct/RichTextLabel
onready var dust1 = $DustAnimation
onready var dust2 = $DustAnimation2
onready var dust3 = $DustAnimation3
onready var dust4 = $DustAnimation4
onready var explosionSound = $AudioStreamPlayer
onready var alarmSound = $AlarmSound
onready var hitBox = $Hitbox/CollisionShape2D
onready var save_file = SaveFile.g_data
const XpOrb = preload("res://Enemies/XpOrbLrg.tscn")
const VictorySound = preload("res://Music and Sounds/VictoryMelody.tscn")




# Called when the node enters the scene tree for the first time.

func _process(delta):
	
	popupD.rect_global_position = self.global_position
	explosionAnim.global_position.x = self.global_position.x + 41
	explosionAnim.global_position.y = self.global_position.y
	popupD.rect_global_position.x = self.global_position.x
	popupD.rect_global_position.y = self.global_position.y - 55
	destructMsg.text = "Self Destruct in: " + str(destructTimer.time_left).split(".")[0]
	if explosionAnim.frame >= 20:
		hitBox.disabled = true

func _ready():
	self.hide()
	self.global_position.y += 3
	timer.start()
	explosionAnim.hide()
	explosionAnim.frame = 71
	hitBox.disabled = true


func _on_Timer_timeout():
	self.show()
	popupD.show()
	destructTimer.start()
	alarmSound.play(0.0)
	
	


func _on_DestructTimer_timeout():
	hitBox.disabled = false
	explosionSound.play(0.0)
	explosionAnim.show()
	var xpOrb = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb)
	xpOrb.global_position = global_position
	var xpOrb2 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb2)
	xpOrb2.global_position = global_position
	xpOrb2.MAX_SPEED = 65
	var xpOrb3 = XpOrb.instance()
	get_parent().call_deferred("add_child", xpOrb3)
	xpOrb3.global_position = global_position
	xpOrb3.MAX_SPEED = 70
	var victorySound = VictorySound.instance()
	get_parent().call_deferred("add_child", victorySound)
	dust1.hide()
	dust2.hide()
	dust3.hide()
	dust4.hide()
	popupD.hide()
	sprite.hide()
	explosionAnim.frame = 0
	explosionAnim.play("explode")
	save_file.world_one_boss_lives = false


func _on_AnimatedSprite_animation_finished():
	self.call_deferred("queue_free")
	SaveFile.save_data()
