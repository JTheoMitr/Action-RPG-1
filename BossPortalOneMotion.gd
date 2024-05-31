extends AnimatedSprite

const PortalSound = preload("res://Music and Sounds/BossPortalOneSound.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var forceField = $StaticBody2D
var stats = PlayerStats
var open = true

# Called when the node enters the scene tree for the first time.
func _ready():
	forceField.collision_layer = false
	self.stop()
	self.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stats.boss_keys == 1:
		self.play("Close", true) #plays the anim backwards
		self.stop()
		self.frame = 0
		forceField.collision_layer = false


func _on_DoorTrigger_area_entered(area):
	if stats.boss_keys == 0:
		self.play("Close")
		if open == true:
			var portalSound = PortalSound.instance()
			get_tree().current_scene.add_child(portalSound)
			forceField.collision_layer = true
			open = false
			# check this



func _on_BossPortalOneMotion_animation_finished():
	self.stop()
	self.frame = 5
