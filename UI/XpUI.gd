extends Control


onready var stats = PlayerStats

func _process(delta):
	$RichTextLabel.text = "xp " + str(stats.xp) + " / " + str(stats.xpCap)

	
func _ready():
	$RichTextLabel.text = "xp " + str(stats.xp) + " / " + str(stats.xpCap)
