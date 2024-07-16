extends Control


onready var stats = PlayerStats
onready var animSprite = $AnimatedSprite

func _process(delta):
	$RichTextLabel.text = "xp " + str(stats.xp) + " / " + str(stats.xpCap)
	
	if stats.xp < (stats.xpCap * .2):
		animSprite.frame = 4
	if stats.xp < (stats.xpCap * .4) && stats.xp > (stats.xpCap * .2):
		animSprite.frame = 3	
	if stats.xp < (stats.xpCap * .65) && stats.xp > (stats.xpCap * .4):
		animSprite.frame = 2	
	if stats.xp < (stats.xpCap * .85) && stats.xp > (stats.xpCap * .65):
		animSprite.frame = 1	
	if stats.xp > (stats.xpCap * .85):
		animSprite.frame = 0
	
func _ready():
	$RichTextLabel.text = "xp " + str(stats.xp) + " / " + str(stats.xpCap)
	
