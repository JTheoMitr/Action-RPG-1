extends Node2D


onready var cover = $Sprite

export var speed := 2.0       # radians/sec
export var min_thickness := 0.15    # edge-on thickness illusion

var t := 0.0

func _process(delta):
	t += delta * speed
	var depth = abs(cos(t))  # 1 → 0 → 1 loop
	cover.scale.x = lerp(min_thickness, 1.0, depth)
	cover.scale.y = 1.0 + 0.03 * sin(t)

