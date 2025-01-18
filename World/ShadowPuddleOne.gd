extends Sprite

const ShadowMan = preload("res://Enemies/ShadowMan.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawned
onready var birthing = $AnimatedSprite
onready var squelch = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	spawned = false
	birthing.hide()
	birthing.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if spawned == false:
		birthing.show()
		birthing.play("default")
		squelch.play(0.0)
		


func _on_Timer_timeout():
	spawned = false


func _on_AnimatedSprite_animation_finished():
	birthing.hide()
	birthing.stop()
	birthing.frame = 0
	var shadowMan = ShadowMan.instance()
	get_parent().call_deferred("add_child", shadowMan)
	shadowMan.global_position = $Area2D/CollisionShape2D.global_position
	spawned = true
