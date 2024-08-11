extends Area2D



onready var dmg = $Hitbox/CollisionShape2D
onready var xplode = $AnimatedSprite
onready var sprite = $C4Intact
onready var timer = $Timer
onready var beep = $Beep
onready var blink = $Blink
onready var damageTimer = $DamageTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	$BlinkTimer.start()
	dmg.disabled = true
	xplode.frame = 71
	sprite.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	xplode.frame = 0
	xplode.play("explode")
	sprite.hide()
	$AudioStreamPlayer.play()
	dmg.disabled = false
	damageTimer.start()
	beep.stop()
	blink.hide()
	$BlinkTimer.stop()
	


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_BombTrap_area_entered(area):
	timer.start(0.0)
	beep.play()


func _on_AlarmSound_finished():
	pass
	#beep.stop()


func _on_BlinkTimer_timeout():
	if blink.visible == true:
		blink.visible = false
	else:
		blink.visible = true


func _on_DamageTimer_timeout():
	dmg.disabled = true
