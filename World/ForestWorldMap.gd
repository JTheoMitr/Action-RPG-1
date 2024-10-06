extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var playerPos = $PlayerPosition
onready var stats = PlayerStats


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	print_debug(playerPos.position)
	if stats.globalPos != null:
		playerPos.position.x = (stats.globalPos.x * .75)
		if stats.globalPos > 0:
			playerPos.position.y = (stats.globalPos.y * .45)
		else:
			playerPos.position.y = (stats.globalPos.y * .75)
