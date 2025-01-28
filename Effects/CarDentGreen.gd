extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var dent = $Dent
onready var openTrunk = $OpenTrunk
const XpOrb = preload("res://Enemies/XpOrb.tscn")
const XpOrb2 = preload("res://Enemies/XpOrb.tscn")
const XpOrb3 = preload("res://Enemies/XpOrb.tscn")
const RedSedanEffect = preload("res://Effects/GreenTrunkEffect.tscn")
const HitEffect = preload("res://Effects/HitEffect.tscn")

var opened
var dented
# Called when the node enters the scene tree for the first time.
func _ready():
	dent.hide()
	openTrunk.hide()
	opened = false
	dented = false

func random_drop_generator(drop_list):
	drop_list.shuffle()
	return drop_list.pop_front()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_pos(value):
	var numberX = random_drop_generator([6, 7, 8])
	var numberY = random_drop_generator([5, 6, 7])
	value.global_position.x = global_position.x + numberX
	value.global_position.y = global_position.y + numberY
	
	
func _on_Hurtbox_area_entered(area):
	if opened == false:
		if dented:
			print_debug("opening")
			dent.hide()
			openTrunk.show()
			var redSedanEffect = RedSedanEffect.instance()
			
			get_parent().add_child(redSedanEffect)
			redSedanEffect.global_position.x = global_position.x + 3
			redSedanEffect.global_position.y = global_position.y + 4
			
			var xp = XpOrb.instance()
			get_parent().call_deferred("add_child", xp)
			call_deferred("set_pos", xp)
			var xp2 = XpOrb2.instance()
			get_parent().call_deferred("add_child", xp2)
			call_deferred("set_pos", xp)
			var xp3 = XpOrb3.instance()
			get_parent().call_deferred("add_child", xp3)
			call_deferred("set_pos", xp)
			opened = true
		else:
			dent.show()
			dented = true
			var effect = HitEffect.instance()
			var main = get_tree().current_scene
			main.add_child(effect)
			effect.global_position.x = global_position.x
			effect.global_position.y = global_position.y + 9
