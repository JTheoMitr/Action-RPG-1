extends Control


onready var stats = PlayerStats
onready var animSprite = $AnimatedSprite

func _process(delta):
	$RichTextLabel.text = "xp " + str(stats.xp) + " / " + str(stats.xpCap)
	
	if stats.xp < (stats.xpCap * .18):
		animSprite.frame = 5
	if stats.xp < (stats.xpCap * .35) && stats.xp > (stats.xpCap * .15):
		animSprite.frame = 4	
	if stats.xp < (stats.xpCap * .6) && stats.xp > (stats.xpCap * .35):
		animSprite.frame = 3	
	if stats.xp < (stats.xpCap * .80) && stats.xp > (stats.xpCap * .6):
		animSprite.frame = 2	
	if stats.xp < (stats.xpCap * .95) && stats.xp > (stats.xpCap * .80):
		animSprite.frame = 1	
	if stats.xp > (stats.xpCap * .85):
		animSprite.frame = 0
	
func _ready():
	$RichTextLabel.text = "xp " + str(stats.xp) + " / " + str(stats.xpCap)
	
