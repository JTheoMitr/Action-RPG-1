extends Area2D


onready var c4 = $C4Intact
onready var dmg = $CollisionShape2DC4
onready var xplode = $AnimatedSprite

onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	c4.show()
	dmg.disabled = true
	xplode.frame = 71
	timer.start(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	xplode.frame = 0
	xplode.play("explode")
	c4.hide()
	dmg.disabled = false
	


func _on_AnimatedSprite_animation_finished():
	queue_free()
