extends Camera2D

var base_offset := Vector2.ZERO

var shake_strength := 0.0
var shake_decay := 20.0
var shake_active := false


func _process(delta):
	if shake_active:
		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)

		var shake = Vector2(
			rand_range(-shake_strength, shake_strength),
			rand_range(-shake_strength, shake_strength)
		)

		offset = base_offset + shake

		if shake_strength <= 0.2:
			shake_strength = 0.0
			shake_active = false
			offset = base_offset
	else:
		offset = base_offset


func screen_shake(strength := 8.0, decay := 20.0) -> void:
	shake_strength = strength
	shake_decay = decay
	shake_active = true

func light_hit_shake():
	screen_shake(3.0, 28.0)

func medium_hit_shake():
	screen_shake(6.0, 22.0)

func explosion_shake():
	screen_shake(12.0, 16.0)
