extends Node2D

const XPO = preload("res://Enemies/XpOrbLrg.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hits
onready var water = $Water
onready var chamber = $Sprite
onready var tink = $Tink
onready var breaking = $Break
onready var cracks = $DynamicCracks
onready var glass = $Glass
onready var drips1 = $AnimatedSprite
onready var drips2 = $AnimatedSprite2
onready var drips3 = $AnimatedSprite3
onready var splash = $Splash

# Called when the node enters the scene tree for the first time.
func _ready():
	hits = 0
	glass.frame = 0
	water.hide()
	water.frame = 0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hits == 0:
		cracks.hide()
	if hits == 1:
		cracks.show()
		cracks.frame = 0

	if hits == 2:
		cracks.frame = 1

	if hits == 3:
		cracks.frame = 2

	if hits == 4:
		cracks.frame = 3

	if hits == 5:
		cracks.hide()

		#play break and glass effect, maybe water effect, item appears....which item(s)?


func _on_Area2D_area_entered(area):
	hits += 1
	
	if hits <= 4:
		tink.play()
	if hits == 5:
		breaking.play()
		glass.play()
		chamber.hide()
		water.show()
		drips1.hide()
		drips2.hide()
		drips3.hide()
		splash.play()
		water.play("default")
		


func _on_Water_animation_finished():
	var xpO = XPO.instance()
	get_parent().add_child(xpO)
	xpO.global_position = cracks.global_position
	queue_free()
