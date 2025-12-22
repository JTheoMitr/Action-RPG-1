extends StaticBody2D

const CrateEffect = preload("res://Effects/CrateEffect.tscn")
const Coin = preload("res://World/Coin.tscn")
const Soda = preload("res://World/SodaPop1.tscn")

const BreakSound = preload("res://Music and Sounds/BarrelBreakSound.tscn")


func set_pos(value):
	value.global_position.x = global_position.x
	value.global_position.y = global_position.y - 1


func create_barrel_effect():
	var crateEffect = CrateEffect.instance()
	var breakAudio = BreakSound.instance()
	get_parent().add_child(breakAudio)
	get_parent().add_child(crateEffect)
	crateEffect.global_position = global_position

	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()


func _on_Hurtbox_area_entered(area):
	create_barrel_effect()
	call_deferred("queue_free")
	var randomDrop = random_drop_generator(["coin", "soda",])
	if (randomDrop == "coin"):
		var coin = Coin.instance()
		get_parent().call_deferred("add_child", coin)
		call_deferred("set_pos", coin)
	elif (randomDrop == "soda"):
		var soda = Soda.instance()
		get_parent().call_deferred("add_child", soda)
		call_deferred("set_pos", soda)
		
		
	

