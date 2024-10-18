extends StaticBody2D

const PortalSound = preload("res://Music and Sounds/LightningPortalSound.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var worldStats = WorldStats
onready var collisionShape = $CollisionShape2D
onready var save_data = SaveFile.g_data

# Called when the node enters the scene tree for the first time.
func _ready():
	worldStats.connect("portal_opened", self, "open_ses")
	if save_data.portal_1_opened == true:
		collisionShape.queue_free()
		$AnimatedSprite.frame = 5
		$AnimatedSprite.stop()
		$LightningSpin.hide()
		$LightningSpin2.hide()
		$LightningSpin3.hide()
	


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
	save_data.portal_1_opened = true
	SaveFile.save_data()
