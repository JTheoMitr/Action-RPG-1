extends Node2D

const ChestEffect = preload("res://Effects/ChestEffect.tscn")



func create_chest_effect():
	var chestEffect = ChestEffect.instance()
	var world = get_tree().current_scene
	get_parent().add_child(chestEffect)
	chestEffect.global_position = global_position



func _on_Hurtbox_area_entered(area):
		create_chest_effect()
		queue_free()
		
		
	

