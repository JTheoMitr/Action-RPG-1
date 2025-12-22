extends Node2D

var front_texture := preload("res://World/roz_cyberdyne.png")
var back_texture  := preload("res://World/roz_cyberdyne_back.png")

onready var cover = $Sprite

export var speed := 2.0
export var min_thickness := 0.15

var t := 0.0
var showing_back := false

func _ready():
	cover.texture = front_texture

func _process(delta):
	t += delta * speed

	var c := cos(t)                 # <-- recompute every frame
	var depth := abs(c)

	cover.scale.x = lerp(min_thickness, 1.0, depth)
	cover.scale.y = 1.0 + 0.03 * sin(t)

	# Determine which side we're on
	var should_show_back := (c < 0.0)

	# Only swap when it changes (prevents flicker)
	if should_show_back != showing_back:
		showing_back = should_show_back
		cover.texture = back_texture if showing_back else front_texture

