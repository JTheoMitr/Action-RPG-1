extends Node2D

const GlassEffect = preload("res://Effects/GlassEffect.tscn")
const Soda = preload("res://World/SodaPop1.tscn")
const Soda2 = preload("res://World/SodaPop2.tscn")
const Soda3 = preload("res://World/SodaPop3.tscn")
const Soda4 = preload("res://World/SodaPop4.tscn")
onready var hurtBox = $Hurtbox
onready var pane = $Pane

func set_pos(value):
	value.global_position.x = global_position.x + 8
	value.global_position.y = global_position.y + 30
	
func create_grass_effect():
	var glassEffect = GlassEffect.instance()
	var world = get_tree().current_scene
	get_parent().add_child(glassEffect)
	glassEffect.global_position.x = global_position.x + 7
	glassEffect.global_position.y = global_position.y + 4
	
func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()


func _on_Hurtbox_area_entered(area):
	pane.hide()
	
	create_grass_effect()
	var randomDrop = random_drop_generator(["drop", "drop", "drop", "drop"])
	if (randomDrop == "drop"):
		var soda = Soda.instance()
		get_parent().call_deferred("add_child", soda)
		call_deferred("set_pos", soda)
	elif (randomDrop == "soda2"):
		var soda = Soda2.instance()
		get_parent().call_deferred("add_child", soda)
		call_deferred("set_pos", soda)
	elif (randomDrop == "soda3"):
		var soda = Soda3.instance()
		get_parent().call_deferred("add_child", soda)
		call_deferred("set_pos", soda)
	elif (randomDrop == "soda4"):
		var soda = Soda4.instance()
		get_parent().call_deferred("add_child", soda)
		call_deferred("set_pos", soda)
		
	hurtBox.call_deferred("queue_free")
	
		
	#queue_free()
