extends StaticBody2D

const PortalSound = preload("res://Music and Sounds/LightningPortalSound.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var worldStats = WorldStats
onready var collisionShape = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	worldStats.connect("portal_2_opened", self, "open_ses")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func open_ses():
	$AnimatedSprite.play("default")
	collisionShape.queue_free()
	var portalSound = PortalSound.instance()
	get_tree().current_scene.add_child(portalSound)


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.frame = 5
	$AnimatedSprite.stop()
	$LightningSpin.hide()
	$LightningSpin2.hide()
	$LightningSpin3.hide()
