extends Control


onready var stats = PlayerStats
onready var animSprite = $AnimatedSprite
var chargeTrue = false
onready var chargeUp = $ChargeUp
onready var charged = $Charged
onready var sprite = $Sprite
onready var blueFrame = $Sprite2

func _process(delta):
	$RichTextLabel.text = "" + str(stats.xp) + " / " + str(stats.xpCap)
	
	if Input.is_action_just_pressed("attack"):
		# bypassing this method to block this special for demo
		
		if chargeTrue == false:
			animSprite.play()
			chargeUp.play()
	
	if Input.is_action_just_released("attack"):
			chargeTrue = false
			animSprite.stop()
			animSprite.frame = 0
			chargeUp.stop()
			sprite.hide()
			blueFrame.hide()
			
#	if stats.xp < (stats.xpCap * .18):
#		animSprite.frame = 5
#	if stats.xp < (stats.xpCap * .35) && stats.xp > (stats.xpCap * .15):
#		animSprite.frame = 4	
#	if stats.xp < (stats.xpCap * .6) && stats.xp > (stats.xpCap * .35):
#		animSprite.frame = 3	
#	if stats.xp < (stats.xpCap * .80) && stats.xp > (stats.xpCap * .6):
#		animSprite.frame = 2	
#	if stats.xp < (stats.xpCap * .95) && stats.xp > (stats.xpCap * .80):
#		animSprite.frame = 1	
#	if stats.xp > (stats.xpCap * .85):
#		animSprite.frame = 0
#
func _ready():
	
	animSprite.frame = 0
	sprite.hide()
	blueFrame.hide()
	


func _on_AnimatedSprite_animation_finished():
	chargeTrue = true
	blueFrame.show()
	animSprite.frame = 7
	animSprite.stop()
	charged.play()
	chargeUp.stop()
	sprite.show()
