extends Node2D

const GrassEffect = preload("res://Effects/PottedPlantEffect.tscn")
const Coin = preload("res://World/Coin.tscn")

func set_pos(value):
	value.global_position.x = global_position.x + 8
	value.global_position.y = global_position.y + 6
	
func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	get_parent().add_child(grassEffect)
	grassEffect.global_position.x = global_position.x + 7
	grassEffect.global_position.y = global_position.y + 4
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()


func _on_Hurtbox_area_entered(area):
	
	create_grass_effect()
	var randomDrop = random_drop_generator(["drop", "none", "none", "none"])
	if (randomDrop == "drop"):
		var coin = Coin.instance()
		get_parent().call_deferred("add_child", coin)
		call_deferred("set_pos", coin)
		
	queue_free()
