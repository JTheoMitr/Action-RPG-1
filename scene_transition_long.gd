extends CanvasLayer

onready var animPlayer = $AnimationPlayer

func change_scene(target: String) -> void:
	animPlayer.play("dissolve")
	yield(animPlayer, "animation_finished")
	get_tree().change_scene(target)
	animPlayer.play_backwards("dissolve")
